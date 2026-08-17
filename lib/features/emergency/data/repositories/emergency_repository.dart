import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/utils/idempotency_utility.dart';
import '../../domain/entities/emergency_models.dart';

abstract class EmergencyRepository {
  Future<Result<Emergency>> report(EmergencyReportPayload payload);
  Future<Result<EmergencyAnalysis>> analyze(String emergencyId);
  Future<Result<Emergency>> respond(String emergencyId, EmergencyResponsePayload payload);
  Future<Result<Emergency>> updateProgress(String emergencyId, ProgressUpdatePayload payload);
  Future<Result<Emergency>> complete(String emergencyId, EmergencyCompletionPayload payload);
  Future<Result<List<Emergency>>> getHistory({String? patientId});
}

class EmergencyRepositoryImpl implements EmergencyRepository {
  final ApiClient _apiClient;

  EmergencyRepositoryImpl(this._apiClient);

  @override
  Future<Result<Emergency>> report(EmergencyReportPayload payload) async {
    final headers = IdempotencyUtility.withIdempotencyHeader(
      null,
      prefix: 'emg-report-${payload.patientId}',
    );

    return await _apiClient.post(
      '/api/v1/emergencies',
      data: payload.toJson(),
      options: Options(headers: headers),
      decoder: (json) => Emergency.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<EmergencyAnalysis>> analyze(String emergencyId) async {
    return await _apiClient.get(
      '/api/v1/emergencies/$emergencyId/analyze',
      decoder: (json) => EmergencyAnalysis.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<Emergency>> respond(
    String emergencyId,
    EmergencyResponsePayload payload,
  ) async {
    final headers = IdempotencyUtility.withIdempotencyHeader(
      null,
      prefix: 'emg-respond-$emergencyId',
    );

    return await _apiClient.post(
      '/api/v1/emergencies/$emergencyId/respond',
      data: payload.toJson(),
      options: Options(headers: headers),
      decoder: (json) => Emergency.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<Emergency>> updateProgress(
    String emergencyId,
    ProgressUpdatePayload payload,
  ) async {
    final headers = IdempotencyUtility.withIdempotencyHeader(
      null,
      prefix: 'emg-update-$emergencyId',
    );

    return await _apiClient.post(
      '/api/v1/emergencies/$emergencyId/update-progress',
      data: payload.toJson(),
      options: Options(headers: headers),
      decoder: (json) => Emergency.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<Emergency>> complete(
    String emergencyId,
    EmergencyCompletionPayload payload,
  ) async {
    final headers = IdempotencyUtility.withIdempotencyHeader(
      null,
      prefix: 'emg-complete-$emergencyId',
    );

    return await _apiClient.post(
      '/api/v1/emergencies/$emergencyId/complete',
      data: payload.toJson(),
      options: Options(headers: headers),
      decoder: (json) => Emergency.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<List<Emergency>>> getHistory({String? patientId}) async {
    final queryParams = <String, dynamic>{};
    if (patientId != null) queryParams['patientId'] = patientId;

    return await _apiClient.get(
      '/api/v1/emergencies/history',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is List) {
          return json.map((e) => Emergency.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <Emergency>[];
      },
    );
  }
}

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EmergencyRepositoryImpl(apiClient);
});
