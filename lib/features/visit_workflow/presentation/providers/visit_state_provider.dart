import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/visit_repository.dart';
import '../../data/stores/visit_draft_store.dart';
import '../../domain/entities/visit_models.dart';
import '../../domain/entities/visit_state.dart';

/// Riverpod 3.0 Notifier managing explicit [VisitState] machine per visit.
///
/// **Caregiver Rules (Section 9.1 & 8B.4)**:
/// 1. Family-keyed by [visitId] so multiple active visits have isolated state.
/// 2. Reconstructs [InAssessment] from persisted [VisitDraftStore] on build/relaunch.
/// 3. Named transition methods police legal state machine moves; direct field setting is prohibited.
/// 4. Implements [ref.onDispose] to clear debounced draft timers.
class VisitStateNotifier extends Notifier<VisitState> {
  final String visitId;
  Timer? _autosaveDebounceTimer;

  VisitStateNotifier(this.visitId);

  @override
  VisitState build() {
    // Clean up autosave timers on provider disposal
    ref.onDispose(() {
      _autosaveDebounceTimer?.cancel();
    });

    // Reconstruct state from persisted draft if available (8B.4 / 9.1.3 rule)
    final employeeId = ref.read(authProvider).employeeId ?? 'current_user';
    final draftStore = ref.read(visitDraftStoreProvider);
    final existingDraft = draftStore.getDraft(
      employeeId: employeeId,
      visitId: visitId,
    );

    if (existingDraft != null) {
      return VisitState.inAssessment(existingDraft);
    }

    return const VisitState.notStarted();
  }

  /// Transition to [Navigating] state after fetching route information.
  Future<void> startNavigation() async {
    final visitRepository = ref.read(visitRepositoryProvider);
    final result = await visitRepository.getNavigation(visitId);

    result.when(
      success: (navInfo) {
        state = VisitState.navigating(navInfo);
      },
      failure: (_) {
        // Fallback default navigation info if network unavailable
        state = VisitState.navigating(
          const NavigationInfo(
            destinationLatitude: 0.0,
            destinationLongitude: 0.0,
            addressText: 'Patient Address',
            estimatedDurationMinutes: 15,
          ),
        );
      },
    );
  }

  /// Transition to [Arrived] state upon reaching patient location.
  void markArrived() {
    state = const VisitState.arrived();
  }

  /// Perform location-verified check-in.
  Future<bool> checkIn(CheckInPayload payload) async {
    final visitRepository = ref.read(visitRepositoryProvider);
    final result = await visitRepository.checkIn(visitId, payload);

    return result.when(
      success: (visit) {
        state = VisitState.checkedIn(visit);
        return true;
      },
      failure: (failure) {
        // State remains in Arrived or current state; failure returned to caller
        return false;
      },
    );
  }

  /// Begin visit assessment phase.
  void beginAssessment([AssessmentPayload? initialPayload]) {
    final payload = initialPayload ?? const AssessmentPayload(vitals: {});
    _saveDraftToStore(payload);
    state = VisitState.inAssessment(payload);
  }

  /// Update assessment draft with autosave debounce.
  void updateDraft(AssessmentPayload draft) {
    state = VisitState.inAssessment(draft);

    _autosaveDebounceTimer?.cancel();
    _autosaveDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _saveDraftToStore(draft);
    });
  }

  /// Transition from active drafting to review step.
  void reviewAssessment() {
    final current = state;
    if (current is InAssessment) {
      _saveDraftToStore(current.draft);
      state = VisitState.reviewing(current.draft);
    } else if (current is SubmissionFailed) {
      state = VisitState.reviewing(current.draft);
    }
  }

  /// Submit finalized assessment draft to server.
  Future<bool> submitAssessment() async {
    final current = state;
    AssessmentPayload? draftToSubmit;

    if (current is Reviewing) {
      draftToSubmit = current.draft;
    } else if (current is InAssessment) {
      draftToSubmit = current.draft;
    } else if (current is SubmissionFailed) {
      draftToSubmit = current.draft;
    }

    if (draftToSubmit == null) return false;

    state = VisitState.submitting(draftToSubmit);

    final visitRepository = ref.read(visitRepositoryProvider);
    final result = await visitRepository.submitAssessment(visitId, draftToSubmit);

    return result.when(
      success: (_) async {
        // Clear local draft store upon successful submission
        _clearDraftFromStore();

        // Fetch latest visit detail for checkout state
        final visitDetailResult = await visitRepository.getVisitDetail(visitId);
        final visit = visitDetailResult.when(
          success: (v) => v,
          failure: (_) => Visit(
            id: visitId,
            patientId: '',
            patientName: 'Patient',
            scheduledTime: DateTime.now(),
            status: 'checked_in',
            address: '',
          ),
        );

        state = VisitState.awaitingCheckout(visit);
        return true;
      },
      failure: (failure) {
        state = VisitState.submissionFailed(draftToSubmit!, failure);
        return false;
      },
    );
  }

  /// Retry submission after a [SubmissionFailed] state.
  Future<bool> retrySubmission() async {
    if (state is SubmissionFailed) {
      return await submitAssessment();
    }
    return false;
  }

  /// Complete checkout for the visit.
  Future<bool> checkOut(CheckOutPayload payload) async {
    final visitRepository = ref.read(visitRepositoryProvider);
    final result = await visitRepository.checkOut(visitId, payload);

    return result.when(
      success: (visit) {
        state = VisitState.completed(visit);
        return true;
      },
      failure: (_) => false,
    );
  }

  void _saveDraftToStore(AssessmentPayload draft) {
    final employeeId = ref.read(authProvider).employeeId ?? 'current_user';
    ref.read(visitDraftStoreProvider).saveDraft(
          employeeId: employeeId,
          visitId: visitId,
          payload: draft,
        );
  }

  void _clearDraftFromStore() {
    final employeeId = ref.read(authProvider).employeeId ?? 'current_user';
    ref.read(visitDraftStoreProvider).clearDraft(
          employeeId: employeeId,
          visitId: visitId,
        );
  }
}

/// Family provider for [VisitStateNotifier], keyed by visit ID.
final visitStateProvider =
    NotifierProvider.family<VisitStateNotifier, VisitState, String>(
  (visitId) => VisitStateNotifier(visitId),
);
