import '../../../../core/network/failure.dart';
import 'visit_models.dart';

/// Explicit sealed class state machine for visit workflow (Section 9.1.2).
///
/// Ensures invalid state combinations (e.g., submitting without a draft,
/// draft before assessment) are impossible to represent at compile time.
sealed class VisitState {
  const VisitState();

  const factory VisitState.notStarted() = NotStarted;
  const factory VisitState.navigating(NavigationInfo navigationInfo) = Navigating;
  const factory VisitState.arrived() = Arrived;
  const factory VisitState.checkedIn(Visit visit) = CheckedIn;
  const factory VisitState.inAssessment(AssessmentPayload draft) = InAssessment;
  const factory VisitState.reviewing(AssessmentPayload draft) = Reviewing;
  const factory VisitState.submitting(AssessmentPayload draft) = Submitting;
  const factory VisitState.submissionFailed(AssessmentPayload draft, Failure failure) = SubmissionFailed;
  const factory VisitState.awaitingCheckout(Visit visit) = AwaitingCheckout;
  const factory VisitState.completed(Visit visit) = Completed;
}

class NotStarted extends VisitState {
  const NotStarted();

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotStarted;

  @override
  int get hashCode => runtimeType.hashCode;
}

class Navigating extends VisitState {
  final NavigationInfo navigationInfo;
  const Navigating(this.navigationInfo);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Navigating && other.navigationInfo == navigationInfo;

  @override
  int get hashCode => navigationInfo.hashCode;
}

class Arrived extends VisitState {
  const Arrived();

  @override
  bool operator ==(Object other) => identical(this, other) || other is Arrived;

  @override
  int get hashCode => runtimeType.hashCode;
}

class CheckedIn extends VisitState {
  final Visit visit;
  const CheckedIn(this.visit);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CheckedIn && other.visit == visit;

  @override
  int get hashCode => visit.hashCode;
}

class InAssessment extends VisitState {
  final AssessmentPayload draft;
  const InAssessment(this.draft);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InAssessment && other.draft == draft;

  @override
  int get hashCode => draft.hashCode;
}

class Reviewing extends VisitState {
  final AssessmentPayload draft;
  const Reviewing(this.draft);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reviewing && other.draft == draft;

  @override
  int get hashCode => draft.hashCode;
}

class Submitting extends VisitState {
  final AssessmentPayload draft;
  const Submitting(this.draft);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Submitting && other.draft == draft;

  @override
  int get hashCode => draft.hashCode;
}

class SubmissionFailed extends VisitState {
  final AssessmentPayload draft;
  final Failure failure;
  const SubmissionFailed(this.draft, this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubmissionFailed &&
          other.draft == draft &&
          other.failure == failure;

  @override
  int get hashCode => Object.hash(draft, failure);
}

class AwaitingCheckout extends VisitState {
  final Visit visit;
  const AwaitingCheckout(this.visit);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AwaitingCheckout && other.visit == visit;

  @override
  int get hashCode => visit.hashCode;
}

class Completed extends VisitState {
  final Visit visit;
  const Completed(this.visit);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Completed && other.visit == visit;

  @override
  int get hashCode => visit.hashCode;
}
