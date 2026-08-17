/// Centralized key constants for secure storage and shared preferences (Section 10A.2).
///
/// Prevents typo'd or duplicate key strings across the app codebase.
abstract class PrefsKeys {
  // --- Secure Storage Tier (flutter_secure_storage) ---
  static const String sessionAuthToken = 'session_auth_token';
  static const String sessionRefreshToken = 'session_refresh_token';
  static const String sessionUserId = 'session_user_id';
  static const String sessionEmployeeId = 'session_employee_id';
  static const String offlinePinBiometricUnlocked = 'offline_pin_biometric_unlocked';
  static const String driftDbEncryptionKey = 'drift_db_encryption_key';

  // --- Non-Sensitive Preferences Tier (shared_preferences) ---
  static const String lastActiveTab = 'last_active_tab';
  static const String protocolLibraryLastViewedCategory =
      'protocol_library_last_viewed_category';
  static const String prefsVersion = 'prefs_version';
}
