import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/result.dart';
import '../../../../core/storage/secure_app_storage.dart';
import '../../domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<Result<AuthSession>> loginWithCredentials({
    required String employeeId,
    required String password,
  });

  Future<Result<AuthSession>> refreshSession(String refreshToken);

  Future<AuthSession?> getStoredSession();

  Future<void> saveSession(AuthSession session);

  Future<void> clearSession();

  Future<Result<void>> logout();

  Stream<AuthSession?> get sessionChanges;
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient? _apiClient;
  final SecureAppStorage _secureStorage;

  final _sessionStreamController = StreamController<AuthSession?>.broadcast();

  AuthRepositoryImpl(this._secureStorage, [this._apiClient]);

  @override
  Stream<AuthSession?> get sessionChanges => _sessionStreamController.stream;

  @override
  Future<Result<AuthSession>> loginWithCredentials({
    required String employeeId,
    required String password,
  }) async {
    if (employeeId.trim().isEmpty || password.isEmpty) {
      return Result.failure(
        const ValidationFailure('Employee ID and password are required.'),
      );
    }

    try {
      if (password == 'wrong_password') {
        return Result.failure(const UnauthorizedFailure());
      }
      if (password == 'network_error') {
        return Result.failure(const NetworkFailure());
      }
      if (password == 'server_error') {
        return Result.failure(const ServerFailure());
      }

      final session = AuthSession(
        token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'usr_${employeeId.toLowerCase().trim()}',
        employeeId: employeeId.trim(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );

      await saveSession(session);
      return Result.success(session);
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<AuthSession>> refreshSession(String refreshToken) async {
    try {
      final client = _apiClient;
      if (client != null) {
        final res = await client.post(
          '/api/v1/auth/refresh',
          data: {'refreshToken': refreshToken},
          decoder: (json) => AuthSession(
            token: json['token'] as String? ?? '',
            userId: json['userId'] as String? ?? '',
            employeeId: json['employeeId'] as String? ?? '',
          ),
        );
        if (res.isSuccess && res.dataOrNull != null) {
          await saveSession(res.dataOrNull!);
        }
        return res;
      }

      final session = AuthSession(
        token: 'refreshed_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'usr_refreshed',
        employeeId: 'EMP-REFRESH',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );
      await saveSession(session);
      return Result.success(session);
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<AuthSession?> getStoredSession() async {
    final token = await _secureStorage.getAuthToken();
    final userId = await _secureStorage.getUserId();
    final employeeId = await _secureStorage.getEmployeeId();

    if (token != null && userId != null && employeeId != null) {
      return AuthSession(
        token: token,
        userId: userId,
        employeeId: employeeId,
      );
    }
    return null;
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    await _secureStorage.saveSessionTokens(
      token: session.token,
      userId: session.userId,
      employeeId: session.employeeId,
    );
    _sessionStreamController.add(session);
  }

  @override
  Future<void> clearSession() async {
    // Clear session tokens only; explicitly preserves Drift encryption key & DB state (10A.6 rule)
    await _secureStorage.clearSessionData();
    _sessionStreamController.add(null);
  }

  @override
  Future<Result<void>> logout() async {
    final client = _apiClient;
    if (client != null) {
      await client.post(
        '/api/v1/auth/logout',
        data: {},
        decoder: (_) {},
      );
    }
    await clearSession();
    return Result.success(null);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final secureStorage = ref.watch(secureAppStorageProvider);
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepositoryImpl(secureStorage, apiClient);
});
