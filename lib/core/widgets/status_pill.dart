import 'package:flutter/material.dart';
import '../../features/visit_workflow/domain/visit_workflow_stage.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Emergency severity levels.
enum EmergencySeverity {
  low,
  medium,
  high,
  critical,
}

/// Caregiver attendance status states.
enum AttendanceStatus {
  clockedIn,
  clockedOut,
  late,
  onLeave,
}

/// Generic & domain-specific status pill component.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  /// Factory constructor for Visit Workflow Stage status pill.
  factory StatusPill.visit(VisitWorkflowStage stage) {
    final (label, bg, text, icon) = switch (stage) {
      VisitWorkflowStage.notStarted => ('Not Started', AppColors.surfaceCard, AppColors.textSecondary, Icons.schedule),
      VisitWorkflowStage.navigating => ('En Route', AppColors.primaryBlueLight.withAlpha(50), AppColors.primaryBlue, Icons.navigation_outlined),
      VisitWorkflowStage.checkedIn => ('Checked In', AppColors.healthGreenLight.withAlpha(80), AppColors.healthGreen, Icons.location_on),
      VisitWorkflowStage.assessment => ('Assessment', AppColors.primaryBlueLight.withAlpha(50), AppColors.primaryBlue, Icons.assignment_outlined),
      VisitWorkflowStage.submission => ('Submitting', AppColors.primaryBlueLight.withAlpha(50), AppColors.primaryBlue, Icons.upload_file),
      VisitWorkflowStage.submissionConfirmed => ('Submitted', AppColors.healthGreenLight.withAlpha(80), AppColors.healthGreen, Icons.check_circle_outline),
      VisitWorkflowStage.checkingOut => ('Checking Out', AppColors.surfaceCard, AppColors.textPrimary, Icons.logout),
      VisitWorkflowStage.visitCompleted => ('Completed', AppColors.healthGreenLight.withAlpha(100), AppColors.healthGreen, Icons.verified),
    };

    return StatusPill(
      label: label,
      backgroundColor: bg,
      textColor: text,
      icon: icon,
    );
  }

  /// Factory constructor for Emergency Severity status pill.
  factory StatusPill.emergency(EmergencySeverity severity) {
    final (label, bg, text, icon) = switch (severity) {
      EmergencySeverity.low => ('Low Priority', const Color(0xFFFEF3C7), const Color(0xFFD97706), Icons.info_outline),
      EmergencySeverity.medium => ('Medium Priority', const Color(0xFFFFEDD5), const Color(0xFFC2410C), Icons.warning_amber_rounded),
      EmergencySeverity.high => ('High Priority', AppColors.emergencyRedBg, AppColors.emergencyRed, Icons.error_outline),
      EmergencySeverity.critical => ('CRITICAL EMERGENCY', AppColors.emergencyRed, AppColors.white, Icons.report_problem),
    };

    return StatusPill(
      label: label,
      backgroundColor: bg,
      textColor: text,
      icon: icon,
    );
  }

  /// Factory constructor for Attendance status pill.
  factory StatusPill.attendance(AttendanceStatus status) {
    final (label, bg, text, icon) = switch (status) {
      AttendanceStatus.clockedIn => ('Clocked In', AppColors.healthGreenLight.withAlpha(80), AppColors.healthGreen, Icons.access_time_filled),
      AttendanceStatus.clockedOut => ('Clocked Out', AppColors.surfaceCard, AppColors.textSecondary, Icons.history),
      AttendanceStatus.late => ('Late Arrival', AppColors.emergencyRedBg, AppColors.emergencyRed, Icons.warning),
      AttendanceStatus.onLeave => ('On Leave', AppColors.primaryBlueLight.withAlpha(50), AppColors.primaryBlue, Icons.event_busy),
    };

    return StatusPill(
      label: label,
      backgroundColor: bg,
      textColor: text,
      icon: icon,
    );
  }

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
