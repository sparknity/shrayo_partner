import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/visit_models.dart';

/// Local store for in-progress visit assessment drafts.
///
/// **Caregiver Rule (Section 8B.4)**:
/// Assessment drafts are scoped by [employeeId] and [visitId].
/// Drafts MUST survive forced or user-initiated logouts, and are ONLY cleared upon:
/// 1. Successful submission ([VisitRepository.submitAssessment])
/// 2. Explicit user-initiated discard action.
class VisitDraftStore {
  // Account-scoped in-memory / local draft table: Map<employeeId, Map<visitId, AssessmentPayload>>
  final Map<String, Map<String, AssessmentPayload>> _drafts = {};

  /// Saves or updates an in-progress assessment draft for a specific caregiver and visit.
  void saveDraft({
    required String employeeId,
    required String visitId,
    required AssessmentPayload payload,
  }) {
    _drafts.putIfAbsent(employeeId, () => {})[visitId] = payload;
  }

  /// Retrieves an unsubmitted assessment draft for a specific caregiver and visit.
  AssessmentPayload? getDraft({
    required String employeeId,
    required String visitId,
  }) {
    return _drafts[employeeId]?[visitId];
  }

  /// Checks if any unsubmitted draft exists for a caregiver.
  bool hasDrafts(String employeeId) {
    final userDrafts = _drafts[employeeId];
    return userDrafts != null && userDrafts.isNotEmpty;
  }

  /// Retrieves all unsubmitted draft visit IDs for a caregiver.
  List<String> getDraftVisitIds(String employeeId) {
    final userDrafts = _drafts[employeeId];
    if (userDrafts == null) return const [];
    return userDrafts.keys.toList();
  }

  /// Explicitly clears a draft upon successful submit or explicit user discard.
  void clearDraft({
    required String employeeId,
    required String visitId,
  }) {
    _drafts[employeeId]?.remove(visitId);
    if (_drafts[employeeId]?.isEmpty ?? false) {
      _drafts.remove(employeeId);
    }
  }

  /// Clears all drafts (for testing or full reset).
  void clearAll() {
    _drafts.clear();
  }
}

/// Provider for [VisitDraftStore].
final visitDraftStoreProvider = Provider<VisitDraftStore>((ref) {
  return VisitDraftStore();
});
