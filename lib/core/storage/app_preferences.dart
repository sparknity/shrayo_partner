import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'prefs_keys.dart';

/// Single wrapper for [SharedPreferences] (Section 10A.2).
///
/// **Caregiver Rules (Section 10A.0, 10A.4 & 10A.5)**:
/// 1. This class is the ONLY place that imports `shared_preferences` directly.
/// 2. Manages non-sensitive UI convenience values (last-active tab, last-viewed protocol category).
/// 3. Implements [prefsVersion] migration checks on initialization.
/// 4. No speculative `onboarding_seen` key is declared (Section 10A.1).
class AppPreferences {
  static const int currentPrefsVersion = 1;
  final SharedPreferences _prefs;

  AppPreferences(this._prefs) {
    _checkMigration();
  }

  /// Initializes [AppPreferences] wrapper asynchronously.
  static Future<AppPreferences> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPreferences(prefs);
  }

  /// Executes version-tagged migration check (Section 10A.5).
  void _checkMigration() {
    final storedVersion = _prefs.getInt(PrefsKeys.prefsVersion) ?? 0;
    if (storedVersion < currentPrefsVersion) {
      // Execute any legacy schema cleanup routines if needed
      _prefs.setInt(PrefsKeys.prefsVersion, currentPrefsVersion);
    }
  }

  // --- Last Active Tab (10A.4.1) ---

  /// Retrieves the last active bottom navigation tab index.
  int getLastActiveTab() {
    return _prefs.getInt(PrefsKeys.lastActiveTab) ?? 0;
  }

  /// Persists the last active bottom navigation tab index.
  Future<bool> setLastActiveTab(int index) {
    return _prefs.setInt(PrefsKeys.lastActiveTab, index);
  }

  // --- Protocol Library Last-Viewed Category (10A.4.2) ---

  /// Key builder for protocol category, optionally account-scoped.
  String _protocolCategoryKey(String? employeeId) {
    if (employeeId != null && employeeId.isNotEmpty) {
      return '${PrefsKeys.protocolLibraryLastViewedCategory}_$employeeId';
    }
    return PrefsKeys.protocolLibraryLastViewedCategory;
  }

  /// Retrieves the last viewed protocol category ID.
  String? getProtocolLastViewedCategory([String? employeeId]) {
    return _prefs.getString(_protocolCategoryKey(employeeId));
  }

  /// Persists the last viewed protocol category ID.
  Future<bool> setProtocolLastViewedCategory(
    String categoryId, [
    String? employeeId,
  ]) {
    return _prefs.setString(_protocolCategoryKey(employeeId), categoryId);
  }

  /// Clears protocol category preference.
  Future<bool> clearProtocolLastViewedCategory([String? employeeId]) {
    return _prefs.remove(_protocolCategoryKey(employeeId));
  }

  // --- General Utilities ---

  /// Clears all preferences (for test cleanup or full reset).
  Future<bool> clearAllPreferences() {
    return _prefs.clear();
  }
}

/// Provider for [AppPreferences].
///
/// Must be overridden in `ProviderScope` main.dart with a pre-initialized instance.
final appPreferencesProvider = Provider<AppPreferences>((ref) {
  throw UnimplementedError('appPreferencesProvider must be overridden in ProviderScope');
});
