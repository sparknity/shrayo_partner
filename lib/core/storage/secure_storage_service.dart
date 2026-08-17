import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'prefs_keys.dart';
import 'secure_app_storage.dart';

/// Key constants for secure storage items (backward compatibility wrapper over [PrefsKeys]).
abstract class SecureStorageKeys {
  static const String authToken = PrefsKeys.sessionAuthToken;
  static const String refreshToken = PrefsKeys.sessionRefreshToken;
  static const String userId = PrefsKeys.sessionUserId;
  static const String employeeId = PrefsKeys.sessionEmployeeId;
}

/// Abstract contract for secure key-value storage.
abstract class SecureStorageService {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();
}

/// Implementation of [SecureStorageService] delegating to [SecureAppStorage].
class FlutterSecureStorageService implements SecureStorageService {
  final SecureAppStorage _appStorage;

  FlutterSecureStorageService({SecureAppStorage? appStorage})
      : _appStorage = appStorage ?? SecureAppStorage();

  @override
  Future<void> write({required String key, required String value}) async {
    await _appStorage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    return await _appStorage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await _appStorage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _appStorage.clearSessionData();
  }
}

/// Provider for [SecureStorageService].
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final appStorage = ref.watch(secureAppStorageProvider);
  return FlutterSecureStorageService(appStorage: appStorage);
});
