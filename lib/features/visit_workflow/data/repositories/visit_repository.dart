import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/utils/idempotency_utility.dart';
import '../../domain/entities/visit_models.dart';

abstract class VisitRepository {
  Future<Result<List<Visit>>> getVisitList({DateTime? date, String? statusFilter});
  Future<Result<Visit>> getVisitDetail(String visitId);
  Future<Result<NavigationInfo>> getNavigation(String visitId);
  Future<Result<Visit>> checkIn(String visitId, CheckInPayload payload);
  Future<Result<Visit>> checkOut(String visitId, CheckOutPayload payload);
  Future<Result<AssessmentResult>> submitAssessment(String visitId, AssessmentPayload payload);
}

class VisitRepositoryImpl implements VisitRepository {
  final ApiClient _apiClient;

  VisitRepositoryImpl(this._apiClient);

  @override
  Future<Result<List<Visit>>> getVisitList({DateTime? date, String? statusFilter}) async {
    final queryParams = <String, dynamic>{};
    if (date != null) queryParams['date'] = date.toIso8601String().split('T').first;
    if (statusFilter != null) queryParams['status'] = statusFilter;

    return await _apiClient.get(
      '/api/v1/visits',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is List) {
          return json.map((e) => Visit.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <Visit>[];
      },
    );
  }

  @override
  Future<Result<Visit>> getVisitDetail(String visitId) async {
    return await _apiClient.get(
      '/api/v1/visits/$visitId',
      decoder: (json) => Visit.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<NavigationInfo>> getNavigation(String visitId) async {
    return await _apiClient.get(
      '/api/v1/visits/$visitId/navigation',
      decoder: (json) => NavigationInfo.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<Visit>> checkIn(String visitId, CheckInPayload payload) async {
    final headers = IdempotencyUtility.withIdempotencyHeader(
      null,
      prefix: 'checkin-$visitId',
    );

    return await _apiClient.post(
      '/api/v1/visits/$visitId/check-in',
      data: payload.toJson(),
      options: Options(headers: headers),
      decoder: (json) => Visit.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<Visit>> checkOut(String visitId, CheckOutPayload payload) async {
    final headers = IdempotencyUtility.withIdempotencyHeader(
      null,
      prefix: 'checkout-$visitId',
    );

    return await _apiClient.post(
      '/api/v1/visits/$visitId/check-out',
      data: payload.toJson(),
      options: Options(headers: headers),
      decoder: (json) => Visit.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<AssessmentResult>> submitAssessment(
    String visitId,
    AssessmentPayload payload,
  ) async {
    final headers = IdempotencyUtility.withIdempotencyHeader(
      null,
      prefix: 'assessment-$visitId',
    );

    return await _apiClient.post(
      '/api/v1/visits/$visitId/assessment',
      data: payload.toJson(),
      options: Options(headers: headers),
      decoder: (json) => AssessmentResult.fromJson(json as Map<String, dynamic>),
    );
  }
}

final visitRepositoryProvider = Provider<VisitRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VisitRepositoryImpl(apiClient);
});
