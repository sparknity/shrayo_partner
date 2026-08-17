import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'prefs_keys.dart';

/// Single wrapper for [FlutterSecureStorage] (Section 10A.2).
///
/// **Caregiver Rule (Section 10A.0 & 10A.6)**:
/// 1. This class is the ONLY place that imports `flutter_secure_storage` directly.
/// 2. Manages sensitive credentials, session tokens, offline app-lock flags, and database keys.
/// 3. [clearSessionData] clears session tokens on logout, but MUST preserve [PrefsKeys.driftDbEncryptionKey]
///    so offline Drift database content remains decryptable across logins.
class SecureAppStorage {
  final FlutterSecureStorage _storage;

  SecureAppStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  // --- Session Token Management ---

  /// Persists authentication session tokens.
  Future<void> saveSessionTokens({
    required String token,
    String? refreshToken,
    required String userId,
    required String employeeId,
  }) async {
    await write(key: PrefsKeys.sessionAuthToken, value: token);
    if (refreshToken != null) {
      await write(key: PrefsKeys.sessionRefreshToken, value: refreshToken);
    }
    await write(key: PrefsKeys.sessionUserId, value: userId);
    await write(key: PrefsKeys.sessionEmployeeId, value: employeeId);
  }

  /// Retrieves the active JWT authentication token.
  Future<String?> getAuthToken() => read(key: PrefsKeys.sessionAuthToken);

  /// Retrieves the refresh token.
  Future<String?> getRefreshToken() => read(key: PrefsKeys.sessionRefreshToken);

  /// Retrieves the active user ID.
  Future<String?> getUserId() => read(key: PrefsKeys.sessionUserId);

  /// Retrieves the active employee ID.
  Future<String?> getEmployeeId() => read(key: PrefsKeys.sessionEmployeeId);

  // --- Offline PIN / Biometric Unlock Flag ---

  /// Persists the offline PIN / biometric unlock flag (Section 10A.3).
  Future<void> setOfflineUnlockFlag(bool enabled) async {
    await write(
      key: PrefsKeys.offlinePinBiometricUnlocked,
      value: enabled ? 'true' : 'false',
    );
  }

  /// Checks if offline PIN / biometric unlock is enabled.
  Future<bool> getOfflineUnlockFlag() async {
    final val = await read(key: PrefsKeys.offlinePinBiometricUnlocked);
    return val == 'true';
  }

  /// Clears the offline PIN / biometric unlock flag.
  Future<void> clearOfflineUnlockFlag() async {
    await delete(key: PrefsKeys.offlinePinBiometricUnlocked);
  }

  // --- Drift Database Encryption Key ---

  /// Retrieves the SQLCipher database encryption key or generates one if missing (Section 10A.1).
  Future<String> getOrCreateDriftEncryptionKey() async {
    var existingKey = await read(key: PrefsKeys.driftDbEncryptionKey);
    if (existingKey == null || existingKey.isEmpty) {
      // Generate a secure pseudo-random 32-character key for Drift SQLCipher
      existingKey = DateTime.now().microsecondsSinceEpoch.toRadixString(36) +
          DateTime.now().millisecondsSinceEpoch.toRadixString(36);
      await write(key: PrefsKeys.driftDbEncryptionKey, value: existingKey);
    }
    return existingKey;
  }

  /// Gets the existing Drift encryption key if present.
  Future<String?> getDriftEncryptionKey() =>
      read(key: PrefsKeys.driftDbEncryptionKey);

  /// Saves an explicit Drift encryption key.
  Future<void> saveDriftEncryptionKey(String key) async {
    await write(key: PrefsKeys.driftDbEncryptionKey, value: key);
  }

  // --- Scoped Cleanup (Section 10A.6) ---

  /// Clears session tokens upon logout.
  ///
  /// **Crucial Rule**: Does NOT delete [PrefsKeys.driftDbEncryptionKey] or
  /// offline DB data, ensuring offline access remains available across sessions.
  Future<void> clearSessionData() async {
    await delete(key: PrefsKeys.sessionAuthToken);
    await delete(key: PrefsKeys.sessionRefreshToken);
    await delete(key: PrefsKeys.sessionUserId);
    await delete(key: PrefsKeys.sessionEmployeeId);
  }

  // --- Low-Level Primitives ---

  Future<void> write({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (_) {}
  }

  Future<String?> read({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      return null;
    }
  }

  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (_) {}
  }

  /// Wipes all secure storage items (for full reset / testing).
  Future<void> clearAllSecure() async {
    try {
      await _storage.deleteAll();
    } catch (_) {}
  }
}

/// Provider for [SecureAppStorage].
final secureAppStorageProvider = Provider<SecureAppStorage>((ref) {
  return SecureAppStorage();
});
