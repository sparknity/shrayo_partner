import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Embedded Blood Pressure Card Widget (Phase 5/11).
class BloodPressureCardWidget extends StatelessWidget {
  final String systolic;
  final String diastolic;
  final VoidCallback onTapDetails;

  const BloodPressureCardWidget({
    super.key,
    required this.systolic,
    required this.diastolic,
    required this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    final bool isElevated = int.tryParse(systolic) != null && int.parse(systolic) > 140;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.cardRadius,
        side: BorderSide(
          color: isElevated ? AppColors.emergencyRed : AppColors.borderDivider,
          width: isElevated ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.favorite, color: AppColors.emergencyRed, size: 20),
                    SizedBox(width: 6),
                    Text('Blood Pressure (BP)', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isElevated ? AppColors.emergencyRedBg : AppColors.healthGreenLight.withAlpha(50),
                    borderRadius: AppSpacing.pillRadius,
                  ),
                  child: Text(
                    isElevated ? 'Stage 1 Elevated' : 'Normal',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isElevated ? AppColors.emergencyRed : AppColors.healthGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$systolic/$diastolic',
                  style: AppTextStyles.displayMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isElevated ? AppColors.emergencyRed : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text('mmHg', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onTapDetails,
                icon: const Icon(Icons.show_chart, size: 16),
                label: const Text('View BP Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
