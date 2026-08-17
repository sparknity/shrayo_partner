import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Developer-only logging interceptor for Dio requests and responses.
/// Redacts sensitive `Authorization` headers to prevent credential leakage in logs.
class LoggingInterceptor extends Interceptor {
  final bool enabled;

  LoggingInterceptor({this.enabled = kDebugMode});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
      if (sanitizedHeaders.containsKey('Authorization')) {
        sanitizedHeaders['Authorization'] = 'Bearer [REDACTED]';
      }

      debugPrint('--> ${options.method} ${options.uri}');
      debugPrint('Headers: $sanitizedHeaders');
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
      debugPrint('--> END ${options.method}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enabled) {
      debugPrint('<-- ${response.statusCode} ${response.requestOptions.uri}');
      if (response.data != null) {
        debugPrint('Response Data: ${response.data}');
      }
      debugPrint('<-- END HTTP');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      debugPrint('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}');
      debugPrint('Error Message: ${err.message}');
      if (err.response?.data != null) {
        debugPrint('Error Response Body: ${err.response?.data}');
      }
      debugPrint('<-- END ERROR');
    }
    handler.next(err);
  }
}
