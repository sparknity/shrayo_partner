import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/utils/idempotency_utility.dart';
import '../../domain/entities/workspace_models.dart';

abstract class WorkspaceRepository {
  Future<Result<CareManagerProfile>> getProfile();
  Future<Result<CareManagerProfile>> updateProfile(ProfileUpdatePayload payload);
  Future<Result<AttendanceRecord>> getAttendance({DateTimeRange? range});
  Future<Result<AttendanceRecord>> clockIn();
  Future<Result<AttendanceRecord>> clockOut();
  Future<Result<List<ScheduleEntry>>> getSchedule({DateTimeRange? range});
  Future<Result<List<WorkspaceTask>>> getTasks({String? statusFilter});
  Future<Result<WorkspaceTask>> updateTaskStatus(String taskId, String newStatus);
  Future<Result<List<WorkspaceDocument>>> getDocuments();
  Future<Result<List<TrainingModule>>> getTraining();
  Future<Result<TrainingProgress>> getTrainingProgress(String moduleId);
  Future<Result<WorkspaceSettings>> getSettings();
  Future<Result<WorkspaceSettings>> updateSettings(SettingsUpdatePayload payload);
}

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final ApiClient _apiClient;

  WorkspaceRepositoryImpl(this._apiClient);

  @override
  Future<Result<CareManagerProfile>> getProfile() async {
    return await _apiClient.get(
      '/api/v1/workspace/profile',
      decoder: (json) => CareManagerProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<CareManagerProfile>> updateProfile(ProfileUpdatePayload payload) async {
    return await _apiClient.put(
      '/api/v1/workspace/profile',
      data: payload.toJson(),
      decoder: (json) => CareManagerProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<AttendanceRecord>> getAttendance({DateTimeRange? range}) async {
    final queryParams = <String, dynamic>{};
    if (range != null) {
      queryParams['start'] = range.start.toIso8601String();
      queryParams['end'] = range.end.toIso8601String();
    }

    return await _apiClient.get(
      '/api/v1/workspace/attendance',
      queryParameters: queryParams,
      decoder: (json) => AttendanceRecord.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<AttendanceRecord>> clockIn() async {
    final headers = IdempotencyUtility.withIdempotencyHeader(
      null,
      prefix: 'clockin',
    );

    return await _apiClient.post(
      '/api/v1/workspace/attendance/clock-in',
      data: {},
      options: Options(headers: headers),
      decoder: (json) => AttendanceRecord.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<AttendanceRecord>> clockOut() async {
    final headers = IdempotencyUtility.withIdempotencyHeader(
      null,
      prefix: 'clockout',
    );

    return await _apiClient.post(
      '/api/v1/workspace/attendance/clock-out',
      data: {},
      options: Options(headers: headers),
      decoder: (json) => AttendanceRecord.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<List<ScheduleEntry>>> getSchedule({DateTimeRange? range}) async {
    final queryParams = <String, dynamic>{};
    if (range != null) {
      queryParams['start'] = range.start.toIso8601String();
      queryParams['end'] = range.end.toIso8601String();
    }

    return await _apiClient.get(
      '/api/v1/workspace/schedule',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is List) {
          return json.map((e) => ScheduleEntry.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <ScheduleEntry>[];
      },
    );
  }

  @override
  Future<Result<List<WorkspaceTask>>> getTasks({String? statusFilter}) async {
    final queryParams = <String, dynamic>{};
    if (statusFilter != null) queryParams['status'] = statusFilter;

    return await _apiClient.get(
      '/api/v1/workspace/tasks',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is List) {
          return json.map((e) => WorkspaceTask.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <WorkspaceTask>[];
      },
    );
  }

  @override
  Future<Result<WorkspaceTask>> updateTaskStatus(String taskId, String newStatus) async {
    return await _apiClient.put(
      '/api/v1/workspace/tasks/$taskId',
      data: {'status': newStatus},
      decoder: (json) => WorkspaceTask.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<List<WorkspaceDocument>>> getDocuments() async {
    return await _apiClient.get(
      '/api/v1/workspace/documents',
      decoder: (json) {
        if (json is List) {
          return json.map((e) => WorkspaceDocument.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <WorkspaceDocument>[];
      },
    );
  }

  @override
  Future<Result<List<TrainingModule>>> getTraining() async {
    return await _apiClient.get(
      '/api/v1/workspace/training',
      decoder: (json) {
        if (json is List) {
          return json.map((e) => TrainingModule.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <TrainingModule>[];
      },
    );
  }

  @override
  Future<Result<TrainingProgress>> getTrainingProgress(String moduleId) async {
    return await _apiClient.get(
      '/api/v1/workspace/training/$moduleId/progress',
      decoder: (json) => TrainingProgress.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<WorkspaceSettings>> getSettings() async {
    return await _apiClient.get(
      '/api/v1/workspace/settings',
      decoder: (json) => WorkspaceSettings.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<WorkspaceSettings>> updateSettings(SettingsUpdatePayload payload) async {
    return await _apiClient.put(
      '/api/v1/workspace/settings',
      data: payload.toJson(),
      decoder: (json) => WorkspaceSettings.fromJson(json as Map<String, dynamic>),
    );
  }
}

final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkspaceRepositoryImpl(apiClient);
});
