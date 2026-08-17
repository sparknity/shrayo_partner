import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/visit_workflow_stage.dart';

/// Holds state for an active visit and queued deferred deep links.
class ActiveVisitState {
  final VisitWorkflowStage stage;
  final String? activeVisitId;
  final String? queuedDeepLink;

  const ActiveVisitState({
    required this.stage,
    this.activeVisitId,
    this.queuedDeepLink,
  });

  const ActiveVisitState.initial()
      : stage = VisitWorkflowStage.notStarted,
        activeVisitId = null,
        queuedDeepLink = null;

  bool get isVisitInProgress => stage.isVisitInProgress;

  ActiveVisitState copyWith({
    VisitWorkflowStage? stage,
    String? activeVisitId,
    String? queuedDeepLink,
    bool clearQueuedDeepLink = false,
    bool clearActiveVisitId = false,
  }) {
    return ActiveVisitState(
      stage: stage ?? this.stage,
      activeVisitId: clearActiveVisitId ? null : (activeVisitId ?? this.activeVisitId),
      queuedDeepLink: clearQueuedDeepLink ? null : (queuedDeepLink ?? this.queuedDeepLink),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveVisitState &&
          runtimeType == other.runtimeType &&
          stage == other.stage &&
          activeVisitId == other.activeVisitId &&
          queuedDeepLink == other.queuedDeepLink;

  @override
  int get hashCode => stage.hashCode ^ activeVisitId.hashCode ^ queuedDeepLink.hashCode;
}

/// Notifier managing active visit workflow stage and deferred deep link queue.
class ActiveVisitNotifier extends Notifier<ActiveVisitState> implements Listenable {
  final List<VoidCallback> _listeners = [];

  @override
  ActiveVisitState build() {
    return const ActiveVisitState.initial();
  }

  @override
  void addListener(VoidCallback listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in List<VoidCallback>.from(_listeners)) {
      listener();
    }
  }

  /// Starts a visit for given [visitId].
  void startVisit(String visitId) {
    state = ActiveVisitState(
      stage: VisitWorkflowStage.checkedIn,
      activeVisitId: visitId,
      queuedDeepLink: state.queuedDeepLink,
    );
    _notifyListeners();
  }

  /// Updates current workflow stage.
  void updateStage(VisitWorkflowStage stage) {
    state = state.copyWith(stage: stage);
    _notifyListeners();
  }

  /// Marks visit as submissionConfirmed and returns any queued deep link.
  String? completeVisit() {
    final pendingLink = state.queuedDeepLink;
    state = const ActiveVisitState.initial();
    _notifyListeners();
    return pendingLink;
  }

  /// Queues a deep link to be processed when active visit completes.
  void queueDeepLink(String route) {
    state = state.copyWith(queuedDeepLink: route);
    _notifyListeners();
  }

  /// Consumes and clears the queued deep link.
  String? consumeQueuedDeepLink() {
    final pendingLink = state.queuedDeepLink;
    if (pendingLink != null) {
      state = state.copyWith(clearQueuedDeepLink: true);
      _notifyListeners();
    }
    return pendingLink;
  }
}

/// Global provider for [ActiveVisitNotifier].
final activeVisitProvider =
    NotifierProvider<ActiveVisitNotifier, ActiveVisitState>(() {
  return ActiveVisitNotifier();
});
