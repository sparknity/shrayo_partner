import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/workspace_repository.dart';
import '../../domain/entities/workspace_models.dart';

/// Granular provider for Care Manager Profile (Section 9.0.1).
final workspaceProfileProvider = FutureProvider<CareManagerProfile>((ref) async {
  final repository = ref.watch(workspaceRepositoryProvider);
  final result = await repository.getProfile();
  return result.when(
    success: (profile) => profile,
    failure: (failure) => throw failure,
  );
});

/// Granular provider for Attendance Record & Clock In/Out actions.
class AttendanceNotifier extends AsyncNotifier<AttendanceRecord> {
  @override
  Future<AttendanceRecord> build() async {
    final repository = ref.watch(workspaceRepositoryProvider);
    final result = await repository.getAttendance();
    return result.when(
      success: (record) => record,
      failure: (failure) => throw failure,
    );
  }

  Future<void> clockIn() async {
    state = const AsyncValue.loading();
    final repository = ref.read(workspaceRepositoryProvider);
    final result = await repository.clockIn();
    state = result.when(
      success: (record) => AsyncValue.data(record),
      failure: (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }

  Future<void> clockOut() async {
    state = const AsyncValue.loading();
    final repository = ref.read(workspaceRepositoryProvider);
    final result = await repository.clockOut();
    state = result.when(
      success: (record) => AsyncValue.data(record),
      failure: (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }
}

final attendanceProvider =
    AsyncNotifierProvider<AttendanceNotifier, AttendanceRecord>(
  AttendanceNotifier.new,
);

/// Granular provider for caregiver work schedule.
final scheduleProvider =
    FutureProvider.family<List<ScheduleEntry>, DateTimeRange?>(
  (ref, range) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    final result = await repository.getSchedule(range: range);
    return result.when(
      success: (schedule) => schedule,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for workspace task list.
final taskListProvider =
    FutureProvider.family<List<WorkspaceTask>, String?>(
  (ref, statusFilter) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    final result = await repository.getTasks(statusFilter: statusFilter);
    return result.when(
      success: (tasks) => tasks,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for workspace documents.
final documentsProvider = FutureProvider<List<WorkspaceDocument>>((ref) async {
  final repository = ref.watch(workspaceRepositoryProvider);
  final result = await repository.getDocuments();
  return result.when(
    success: (docs) => docs,
    failure: (failure) => throw failure,
  );
});

/// Granular provider for training modules list.
final trainingListProvider = FutureProvider<List<TrainingModule>>((ref) async {
  final repository = ref.watch(workspaceRepositoryProvider);
  final result = await repository.getTraining();
  return result.when(
    success: (modules) => modules,
    failure: (failure) => throw failure,
  );
});

/// Granular provider for training progress per module.
final trainingProgressProvider =
    FutureProvider.family<TrainingProgress, String>(
  (ref, moduleId) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    final result = await repository.getTrainingProgress(moduleId);
    return result.when(
      success: (progress) => progress,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for workspace settings.
final workspaceSettingsProvider = FutureProvider<WorkspaceSettings>((ref) async {
  final repository = ref.watch(workspaceRepositoryProvider);
  final result = await repository.getSettings();
  return result.when(
    success: (settings) => settings,
    failure: (failure) => throw failure,
  );
});
