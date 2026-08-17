import 'dart:async';
import 'package:dio/dio.dart';

/// Interceptor that retries failed idempotent GET requests with exponential backoff.
/// Explicitly excludes state-transition write operations (POST, PUT, DELETE, PATCH).
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration initialDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(milliseconds: 500),
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    // Retry ONLY idempotent GET requests
    final isGet = requestOptions.method.toUpperCase() == 'GET';
    final retryCount = requestOptions.extra['retry_count'] as int? ?? 0;

    final shouldRetry = isGet &&
        retryCount < maxRetries &&
        _shouldRetryException(err);

    if (shouldRetry) {
      requestOptions.extra['retry_count'] = retryCount + 1;
      final delay = initialDelay * (1 << retryCount);

      await Future.delayed(delay);

      try {
        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } on DioException catch (retryErr) {
        return handler.next(retryErr);
      } catch (e) {
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  bool _shouldRetryException(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response != null && err.response!.statusCode! >= 500);
  }
}
