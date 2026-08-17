import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';
import 'status_pill.dart';

/// Clock-in / clock-out card for caregiver attendance tracking (Section 5.2).
class AttendanceStatusCard extends StatelessWidget {
  const AttendanceStatusCard({
    super.key,
    required this.isClockedIn,
    this.shiftStartTime,
    this.shiftDuration,
    this.locationVerified = true,
    this.onClockInOutPressed,
  });

  final bool isClockedIn;
  final String? shiftStartTime;
  final String? shiftDuration;
  final bool locationVerified;
  final VoidCallback? onClockInOutPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surfaceBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        side: const BorderSide(color: AppColors.borderDivider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shift Attendance',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                StatusPill.attendance(
                  isClockedIn ? AttendanceStatus.clockedIn : AttendanceStatus.clockedOut,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Clock-In Time', style: AppTextStyles.caption),
                      const SizedBox(height: 2),
                      Text(
                        shiftStartTime ?? '--:--',
                        style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Shift Duration', style: AppTextStyles.caption),
                      const SizedBox(height: 2),
                      Text(
                        shiftDuration ?? '0h 0m',
                        style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Row(
              children: [
                Icon(
                  locationVerified ? Icons.verified : Icons.warning_amber_rounded,
                  size: 14,
                  color: locationVerified ? AppColors.healthGreen : const Color(0xFFD97706),
                ),
                const SizedBox(width: 4),
                Text(
                  locationVerified ? 'GPS Location Verified' : 'GPS Verification Pending',
                  style: AppTextStyles.caption.copyWith(
                    color: locationVerified ? AppColors.healthGreen : const Color(0xFFD97706),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            AppButton(
              label: isClockedIn ? 'Clock Out of Shift' : 'Clock In to Shift',
              variant: isClockedIn ? AppButtonVariant.outline : AppButtonVariant.primary,
              onPressed: onClockInOutPressed,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
