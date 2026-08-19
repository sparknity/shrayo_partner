import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/utils/idempotency_utility.dart';
import '../../domain/entities/home_models.dart';

abstract class HomeRepository {
  Future<Result<HomeDashboardData>> getDashboardData({
    DateTime? date,
    double? latitude,
    double? longitude,
  });

  Future<Result<CaregiverProfile>> getProfile();

  Future<Result<void>> updateShiftStatus({
    required ShiftStatus status,
    String? reason,
    required double latitude,
    required double longitude,
  });

  Future<Result<DailyProgress>> getDailyProgress({DateTime? date});

  Future<Result<CurrentVisitHero?>> getCurrentVisit({
    double? latitude,
    double? longitude,
  });

  Future<Result<List<ActivityItem>>> getRecentActivities({
    int page = 1,
    int limit = 10,
    String? filter,
  });

  Future<Result<List<UpcomingScheduleItem>>> getUpcomingSchedule({
    String? filter,
  });

  Future<Result<CareIntelligenceItem?>> getCareIntelligence({
    String? patientId,
  });

  Future<Result<void>> acknowledgeCareIntelligence(String insightId);

  Future<Result<void>> sendLocationHeartbeat({
    required double latitude,
    required double longitude,
    required double accuracy,
    double? speed,
    double? heading,
    int? batteryLevel,
    bool isCharging = false,
  });
}

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;

  HomeRepositoryImpl(this._apiClient);

  @override
  Future<Result<HomeDashboardData>> getDashboardData({
    DateTime? date,
    double? latitude,
    double? longitude,
  }) async {
    final queryParams = <String, dynamic>{};
    if (date != null) {
      queryParams['date'] = date.toIso8601String().split('T').first;
    }
    if (latitude != null) queryParams['latitude'] = latitude;
    if (longitude != null) queryParams['longitude'] = longitude;

    return await _apiClient.get(
      '/api/v1/home/dashboard',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'] as Map<String, dynamic>? ?? json;
          return HomeDashboardData.fromJson(data);
        }
        return HomeDashboardData.fromJson({});
      },
    );
  }

  @override
  Future<Result<CaregiverProfile>> getProfile() async {
    return await _apiClient.get(
      '/api/v1/home/profile',
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'] as Map<String, dynamic>? ?? json;
          return CaregiverProfile.fromJson(data);
        }
        return CaregiverProfile.fromJson({});
      },
    );
  }

  @override
  Future<Result<void>> updateShiftStatus({
    required ShiftStatus status,
    String? reason,
    required double latitude,
    required double longitude,
  }) async {
    final headers = IdempotencyUtility.withIdempotencyHeader(
      null,
      prefix: 'shift-${status.name}',
    );

    return await _apiClient.patch(
      '/api/v1/home/shift-status',
      data: {
        'shiftStatus': status.toApiString(),
        'reason': reason,
        'currentLocation': {
          'latitude': latitude,
          'longitude': longitude,
        },
      },
      options: headers != null ? Options(headers: headers) : null,
      decoder: (_) {},
    );
  }

  @override
  Future<Result<DailyProgress>> getDailyProgress({DateTime? date}) async {
    final queryParams = <String, dynamic>{};
    if (date != null) {
      queryParams['date'] = date.toIso8601String().split('T').first;
    }

    return await _apiClient.get(
      '/api/v1/home/daily-progress',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'] as Map<String, dynamic>? ?? json;
          return DailyProgress.fromJson(data);
        }
        return DailyProgress.fromJson({});
      },
    );
  }

  @override
  Future<Result<CurrentVisitHero?>> getCurrentVisit({
    double? latitude,
    double? longitude,
  }) async {
    final queryParams = <String, dynamic>{};
    if (latitude != null) queryParams['latitude'] = latitude;
    if (longitude != null) queryParams['longitude'] = longitude;

    return await _apiClient.get(
      '/api/v1/home/current-visit',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'] as Map<String, dynamic>? ?? json;
          return CurrentVisitHero.fromJson(data);
        }
        return null;
      },
    );
  }

  @override
  Future<Result<List<ActivityItem>>> getRecentActivities({
    int page = 1,
    int limit = 10,
    String? filter,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (filter != null) queryParams['filter'] = filter;

    return await _apiClient.get(
      '/api/v1/home/recent-activities',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is Map<String, dynamic> && json['data'] is Map<String, dynamic>) {
          final items = json['data']['items'] as List?;
          return items
                  ?.map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [];
        }
        return <ActivityItem>[];
      },
    );
  }

  @override
  Future<Result<List<UpcomingScheduleItem>>> getUpcomingSchedule({
    String? filter,
  }) async {
    final queryParams = <String, dynamic>{};
    if (filter != null) queryParams['filter'] = filter;

    return await _apiClient.get(
      '/api/v1/home/upcoming-schedule',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is Map<String, dynamic> && json['data'] is Map<String, dynamic>) {
          final timeline = json['data']['timeline'] as List?;
          return timeline
                  ?.map(
                    (e) =>
                        UpcomingScheduleItem.fromJson(e as Map<String, dynamic>),
                  )
                  .toList() ??
              [];
        }
        return <UpcomingScheduleItem>[];
      },
    );
  }

  @override
  Future<Result<CareIntelligenceItem?>> getCareIntelligence({
    String? patientId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (patientId != null) queryParams['patientId'] = patientId;

    return await _apiClient.get(
      '/api/v1/home/care-intelligence',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'] as Map<String, dynamic>? ?? json;
          return CareIntelligenceItem.fromJson(data);
        }
        return null;
      },
    );
  }

  @override
  Future<Result<void>> acknowledgeCareIntelligence(String insightId) async {
    return await _apiClient.post(
      '/api/v1/home/care-intelligence/$insightId/acknowledge',
      data: {},
      decoder: (_) {},
    );
  }

  @override
  Future<Result<void>> sendLocationHeartbeat({
    required double latitude,
    required double longitude,
    required double accuracy,
    double? speed,
    double? heading,
    int? batteryLevel,
    bool isCharging = false,
  }) async {
    return await _apiClient.post(
      '/api/v1/home/location/heartbeat',
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'accuracyMeters': accuracy,
        'speedMps': speed,
        'headingDegrees': heading,
        'batteryLevel': batteryLevel,
        'isCharging': isCharging,
        'recordedAt': DateTime.now().toUtc().toIso8601String(),
      },
      decoder: (_) {},
    );
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HomeRepositoryImpl(apiClient);
});
