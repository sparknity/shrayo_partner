import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/failure.dart';
import '../../data/repositories/auth_repository.dart';

/// Represents the authentication state of the Caregiver App user.
class AuthState {
  final bool isAuthenticated;
  final bool isInitialized;
  final bool isLoading;
  final String? userId;
  final String? employeeId;
  final String? errorMessage;
  final Failure? failure;

  const AuthState({
    required this.isAuthenticated,
    this.isInitialized = false,
    this.isLoading = false,
    this.userId,
    this.employeeId,
    this.errorMessage,
    this.failure,
  });

  const AuthState.unauthenticated({this.isInitialized = true})
      : isAuthenticated = false,
        isLoading = false,
        userId = null,
        employeeId = null,
        errorMessage = null,
        failure = null;

  const AuthState.authenticated({
    required this.userId,
    required this.employeeId,
    this.isInitialized = true,
  })  : isAuthenticated = true,
        isLoading = false,
        errorMessage = null,
        failure = null;

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isInitialized,
    bool? isLoading,
    String? userId,
    String? employeeId,
    String? errorMessage,
    Failure? failure,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      employeeId: employeeId ?? this.employeeId,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          isAuthenticated == other.isAuthenticated &&
          isInitialized == other.isInitialized &&
          isLoading == other.isLoading &&
          userId == other.userId &&
          employeeId == other.employeeId &&
          errorMessage == other.errorMessage &&
          failure == other.failure;

  @override
  int get hashCode =>
      isAuthenticated.hashCode ^
      isInitialized.hashCode ^
      isLoading.hashCode ^
      userId.hashCode ^
      employeeId.hashCode ^
      errorMessage.hashCode ^
      failure.hashCode;
}

/// Riverpod [Notifier] managing auth state while implementing [Listenable]
/// for direct integration with `GoRouter`'s `refreshListenable`.
class AuthNotifier extends Notifier<AuthState> implements Listenable {
  final List<VoidCallback> _listeners = [];

  @override
  AuthState build() {
    // Schedule cold-start session check on next microtask
    Future.microtask(() => checkAuthStatus());
    return const AuthState.unauthenticated(isInitialized: false);
  }

  @override
  void addListener(VoidCallback listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in List<VoidCallback>.from(_listeners)) {
      listener();
    }
  }

  /// Checks secure storage for a persisted session during app cold-start.
  Future<void> checkAuthStatus() async {
    try {
      if (!ref.mounted) return;
      final repository = ref.read(authRepositoryProvider);
      final storedSession = await repository.getStoredSession();

      if (!ref.mounted) return;

      if (storedSession != null && !storedSession.isExpired) {
        state = AuthState.authenticated(
          userId: storedSession.userId,
          employeeId: storedSession.employeeId,
          isInitialized: true,
        );
      } else {
        state = const AuthState.unauthenticated(isInitialized: true);
      }
    } catch (_) {
      if (ref.mounted) {
        state = const AuthState.unauthenticated(isInitialized: true);
      }
    } finally {
      if (ref.mounted) {
        _notifyListeners();
      }
    }
  }

  /// Direct login helper for testing and mock setup.
  void login(String userId) {
    state = AuthState.authenticated(
      userId: userId,
      employeeId: userId,
      isInitialized: true,
    );
    _notifyListeners();
  }

  /// Authenticates using employee ID and password.
  Future<bool> loginWithCredentials({
    required String employeeId,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, failure: null);
    _notifyListeners();

    if (!ref.mounted) return false;
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.loginWithCredentials(
      employeeId: employeeId,
      password: password,
    );

    if (!ref.mounted) return false;

    return result.when(
      success: (session) {
        state = AuthState.authenticated(
          userId: session.userId,
          employeeId: session.employeeId,
          isInitialized: true,
        );
        _notifyListeners();
        return true;
      },
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          failure: failure,
        );
        _notifyListeners();
        return false;
      },
    );
  }

  /// Performs logout, clearing local session storage.
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    _notifyListeners();

    try {
      if (!ref.mounted) return;
      final repository = ref.read(authRepositoryProvider);
      await repository.clearSession();
    } finally {
      if (ref.mounted) {
        state = const AuthState.unauthenticated(isInitialized: true);
        _notifyListeners();
      }
    }
  }

  /// Clears any transient error message.
  void clearError() {
    if (state.errorMessage != null || state.failure != null) {
      state = state.copyWith(errorMessage: null, failure: null);
      _notifyListeners();
    }
  }
}

/// Global provider for [AuthNotifier].
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
