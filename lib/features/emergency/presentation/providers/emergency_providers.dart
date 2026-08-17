import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/failure.dart';
import '../../data/repositories/emergency_repository.dart';
import '../../domain/entities/emergency_models.dart';

/// State holding active emergency details and multi-writer conflict failure status.
class EmergencyDetailState {
  final Emergency emergency;
  final EmergencyAnalysis? analysis;
  final Failure? actionFailure;

  const EmergencyDetailState({
    required this.emergency,
    this.analysis,
    this.actionFailure,
  });

  bool get hasConflict => actionFailure is ConflictFailure;

  EmergencyDetailState copyWith({
    Emergency? emergency,
    EmergencyAnalysis? analysis,
    Failure? actionFailure,
    bool clearFailure = false,
  }) {
    return EmergencyDetailState(
      emergency: emergency ?? this.emergency,
      analysis: analysis ?? this.analysis,
      actionFailure: clearFailure ? null : (actionFailure ?? this.actionFailure),
    );
  }
}

/// Granular provider for emergency history list.
final emergencyHistoryProvider =
    FutureProvider.family<List<Emergency>, String?>(
  (ref, patientId) async {
    final repository = ref.watch(emergencyRepositoryProvider);
    final result = await repository.getHistory(patientId: patientId);
    return result.when(
      success: (history) => history,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for active emergency detail, handling multi-writer conflicts (Section 9.3).
class EmergencyDetailNotifier extends Notifier<EmergencyDetailState> {
  final String emergencyId;

  EmergencyDetailNotifier(this.emergencyId);

  @override
  EmergencyDetailState build() {
    _loadEmergency(emergencyId);
    return EmergencyDetailState(
      emergency: Emergency(
        id: emergencyId,
        patientId: '',
        patientName: 'Patient',
        severity: 'high',
        status: 'active',
        description: 'Emergency reported',
        reportedAt: DateTime.now(),
      ),
    );
  }

  Future<void> _loadEmergency(String id) async {
    final repository = ref.read(emergencyRepositoryProvider);
    final historyResult = await repository.getHistory();

    final emergency = historyResult.when(
      success: (list) {
        return list.firstWhere(
          (e) => e.id == id,
          orElse: () => state.emergency,
        );
      },
      failure: (_) => state.emergency,
    );

    final analysisResult = await repository.analyze(id);
    final analysis = analysisResult.when(
      success: (a) => a,
      failure: (_) => null,
    );

    state = state.copyWith(
      emergency: emergency,
      analysis: analysis,
    );
  }

  /// Respond to an active emergency. Surfacing [ConflictFailure] explicitly if multi-writer race occurs.
  Future<bool> respond(EmergencyResponsePayload payload) async {
    final repository = ref.read(emergencyRepositoryProvider);
    final result = await repository.respond(emergencyId, payload);

    return result.when(
      success: (updatedEmergency) {
        state = state.copyWith(
          emergency: updatedEmergency,
          clearFailure: true,
        );
        return true;
      },
      failure: (failure) {
        state = state.copyWith(actionFailure: failure);
        return false;
      },
    );
  }

  /// Update emergency progress.
  Future<bool> updateProgress(ProgressUpdatePayload payload) async {
    final repository = ref.read(emergencyRepositoryProvider);
    final result = await repository.updateProgress(emergencyId, payload);

    return result.when(
      success: (updatedEmergency) {
        state = state.copyWith(
          emergency: updatedEmergency,
          clearFailure: true,
        );
        return true;
      },
      failure: (failure) {
        state = state.copyWith(actionFailure: failure);
        return false;
      },
    );
  }

  /// Complete emergency workflow.
  Future<bool> complete(EmergencyCompletionPayload payload) async {
    final repository = ref.read(emergencyRepositoryProvider);
    final result = await repository.complete(emergencyId, payload);

    return result.when(
      success: (updatedEmergency) {
        state = state.copyWith(
          emergency: updatedEmergency,
          clearFailure: true,
        );
        return true;
      },
      failure: (failure) {
        state = state.copyWith(actionFailure: failure);
        return false;
      },
    );
  }
}

final emergencyDetailProvider = NotifierProvider.family<
    EmergencyDetailNotifier, EmergencyDetailState, String>(
  (emergencyId) => EmergencyDetailNotifier(emergencyId),
);
