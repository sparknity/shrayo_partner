import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Status states for caregiver leave requests.
enum LeaveRequestStatus {
  pending,
  approved,
  rejected,
  cancelled,
}

/// Dedicated status pill for caregiver leave requests with distinct palette (Section 5.2).
class LeaveRequestStatusPill extends StatelessWidget {
  const LeaveRequestStatusPill({
    super.key,
    required this.status,
  });

  final LeaveRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, text, icon) = switch (status) {
      LeaveRequestStatus.pending => ('Pending Approval', const Color(0xFFFEF3C7), const Color(0xFFD97706), Icons.hourglass_empty),
      LeaveRequestStatus.approved => ('Approved', AppColors.healthGreenLight.withAlpha(80), AppColors.healthGreen, Icons.check_circle_outline),
      LeaveRequestStatus.rejected => ('Rejected', AppColors.emergencyRedBg, AppColors.emergencyRed, Icons.cancel_outlined),
      LeaveRequestStatus.cancelled => ('Cancelled', AppColors.surfaceCard, AppColors.textSecondary, Icons.remove_circle_outline),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s + 2, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: text),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
