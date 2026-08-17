import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage_service.dart';
import 'failure.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'result.dart';

/// Configurable ApiClient wrapping Dio for network communication across the Care Manager App.
class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  factory ApiClient({
    required SecureStorageService secureStorage,
    String? baseUrl,
    Dio? customDio,
  }) {
    const defaultBaseUrl = String.fromEnvironment(
      'API_URL',
      defaultValue: 'https://api-dev.parentcare.app',
    );

    final dio =
        customDio ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl ?? defaultBaseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    // Register Interceptors
    dio.interceptors.addAll([
      AuthInterceptor(secureStorage),
      RetryInterceptor(dio: dio),
      LoggingInterceptor(enabled: kDebugMode),
    ]);

    return ApiClient._(dio);
  }

  /// Maps a [DioException] into a domain-specific [Failure].
  Failure mapDioErrorToFailure(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        String? message;
        if (responseData is Map && responseData.containsKey('message')) {
          message = responseData['message']?.toString();
        }

        if (statusCode == 401 || statusCode == 403) {
          return UnauthorizedFailure(message ?? 'Unauthorized access');
        } else if (statusCode == 409) {
          return ConflictFailure(
            message ?? 'Resource state conflict. Action cannot be completed.',
          );
        } else if (statusCode == 400 || statusCode == 422) {
          return ValidationFailure(message ?? 'Invalid request parameters');
        } else if (statusCode != null && statusCode >= 500) {
          return ServerFailure(message ?? 'Server error ($statusCode)');
        }
        return UnknownFailure(message ?? 'HTTP $statusCode error');

      case DioExceptionType.cancel:
        return const UnknownFailure('Request was cancelled');

      case DioExceptionType.unknown:
      default:
        return UnknownFailure(
          error.message ?? 'An unexpected network error occurred',
        );
    }
  }

  /// Generic GET request wrapper returning [Result<T>].
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) decoder,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return Result.success(decoder(response.data));
    } on DioException catch (e) {
      return Result.failure(mapDioErrorToFailure(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  /// Generic POST request wrapper returning [Result<T>].
  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) decoder,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Result.success(decoder(response.data));
    } on DioException catch (e) {
      return Result.failure(mapDioErrorToFailure(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  /// Generic PUT request wrapper returning [Result<T>].
  Future<Result<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) decoder,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Result.success(decoder(response.data));
    } on DioException catch (e) {
      return Result.failure(mapDioErrorToFailure(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  /// Generic PATCH request wrapper returning [Result<T>].
  Future<Result<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) decoder,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Result.success(decoder(response.data));
    } on DioException catch (e) {
      return Result.failure(mapDioErrorToFailure(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  /// Generic DELETE request wrapper returning [Result<T>].
  Future<Result<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) decoder,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Result.success(decoder(response.data));
    } on DioException catch (e) {
      return Result.failure(mapDioErrorToFailure(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}

/// Provider for [ApiClient].
final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return ApiClient(secureStorage: secureStorage);
});
