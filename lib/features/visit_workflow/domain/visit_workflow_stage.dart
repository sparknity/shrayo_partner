/// Represents stages in a Caregiver visit workflow.
enum VisitWorkflowStage {
  notStarted,
  navigating,
  checkedIn,
  assessment,
  submission,
  submissionConfirmed,
  checkingOut,
  visitCompleted,
}

extension VisitWorkflowStageX on VisitWorkflowStage {
  /// Returns `true` if a visit is active and in-progress between [VisitWorkflowStage.checkedIn]
  /// and [VisitWorkflowStage.checkingOut] (inclusive of checkedIn, exclusive of visitCompleted).
  bool get isVisitInProgress =>
      index >= VisitWorkflowStage.checkedIn.index &&
      index < VisitWorkflowStage.visitCompleted.index;

  /// Returns the step display label for indicators and banners.
  String get stepLabel => switch (this) {
        VisitWorkflowStage.notStarted => 'Not Started',
        VisitWorkflowStage.navigating => 'Step 1: Navigation',
        VisitWorkflowStage.checkedIn => 'Step 2: Check-In',
        VisitWorkflowStage.assessment => 'Step 3: Assessment',
        VisitWorkflowStage.submission => 'Step 4: Review',
        VisitWorkflowStage.submissionConfirmed => 'Step 5: Submit',
        VisitWorkflowStage.checkingOut => 'Step 6: Check-Out',
        VisitWorkflowStage.visitCompleted => 'Completed',
      };

  /// Returns the corresponding route path for this stage given a [visitId].
  String? routePath(String visitId) => switch (this) {
        VisitWorkflowStage.notStarted => null,
        VisitWorkflowStage.navigating => '/visit/$visitId/navigate',
        VisitWorkflowStage.checkedIn => '/visit/$visitId/check-in',
        VisitWorkflowStage.assessment => '/visit/$visitId/assessment',
        VisitWorkflowStage.submission => '/visit/$visitId/review',
        VisitWorkflowStage.submissionConfirmed => '/visit/$visitId/submit',
        VisitWorkflowStage.checkingOut => '/visit/$visitId/checkout',
        VisitWorkflowStage.visitCompleted => null,
      };
}
