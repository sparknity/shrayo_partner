import 'package:flutter/material.dart';
import '../../features/visit_workflow/domain/visit_workflow_stage.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// 6-stage Visit Workflow Step Model.
class WorkflowStepItem {
  const WorkflowStepItem({
    required this.stage,
    required this.title,
    required this.stepIndex,
  });

  final VisitWorkflowStage stage;
  final String title;
  final int stepIndex;
}

/// Step Progress Indicator widget for Caregiver Visit Workflow (Phase 5.1.2).
///
/// **Corrected Stage Sequence**:
/// 1. Navigation
/// 2. Check-In
/// 3. Assessment
/// 4. Review
/// 5. Submit
/// 6. Check-Out (terminates at Visit Completed)
class StepProgressIndicator extends StatelessWidget {
  const StepProgressIndicator({
    super.key,
    required this.currentStage,
    this.onStepTapped,
  });

  final VisitWorkflowStage currentStage;
  final ValueChanged<VisitWorkflowStage>? onStepTapped;

  static const List<WorkflowStepItem> steps = [
    WorkflowStepItem(stage: VisitWorkflowStage.navigating, title: 'Navigate', stepIndex: 1),
    WorkflowStepItem(stage: VisitWorkflowStage.checkedIn, title: 'Check-In', stepIndex: 2),
    WorkflowStepItem(stage: VisitWorkflowStage.assessment, title: 'Assess', stepIndex: 3),
    WorkflowStepItem(stage: VisitWorkflowStage.submission, title: 'Review', stepIndex: 4),
    WorkflowStepItem(stage: VisitWorkflowStage.submissionConfirmed, title: 'Submit', stepIndex: 5),
    WorkflowStepItem(stage: VisitWorkflowStage.checkingOut, title: 'Check-Out', stepIndex: 6),
  ];

  int _getStageIndex(VisitWorkflowStage stage) {
    switch (stage) {
      case VisitWorkflowStage.notStarted:
        return 0;
      case VisitWorkflowStage.navigating:
        return 1;
      case VisitWorkflowStage.checkedIn:
        return 2;
      case VisitWorkflowStage.assessment:
        return 3;
      case VisitWorkflowStage.submission:
        return 4;
      case VisitWorkflowStage.submissionConfirmed:
        return 5;
      case VisitWorkflowStage.checkingOut:
      case VisitWorkflowStage.visitCompleted:
        return 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _getStageIndex(currentStage);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.m,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: List.generate(steps.length, (index) {
              final step = steps[index];
              final stepNum = step.stepIndex;
              final isCompleted = stepNum < activeIndex;
              final isCurrent = stepNum == activeIndex;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onStepTapped != null ? () => onStepTapped!(step.stage) : null,
                        child: Column(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? AppColors.healthGreen
                                    : (isCurrent ? AppColors.primaryBlue : AppColors.surfaceCard),
                                shape: BoxShape.circle,
                                border: isCurrent
                                    ? Border.all(color: AppColors.primaryBlueLight, width: 2)
                                    : null,
                              ),
                              child: Center(
                                child: isCompleted
                                    ? const Icon(Icons.check, size: 16, color: AppColors.white)
                                    : Text(
                                        '$stepNum',
                                        style: AppTextStyles.labelMedium.copyWith(
                                          color: isCurrent ? AppColors.white : AppColors.textSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              step.title,
                              style: AppTextStyles.labelSmall.copyWith(
                                fontSize: 10,
                                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                                color: isCurrent
                                    ? AppColors.primaryBlue
                                    : (isCompleted ? AppColors.healthGreen : AppColors.textSecondary),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index < steps.length - 1)
                      Container(
                        height: 2,
                        width: 12,
                        margin: const EdgeInsets.only(bottom: 14),
                        color: stepNum < activeIndex ? AppColors.healthGreen : AppColors.borderDivider,
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
