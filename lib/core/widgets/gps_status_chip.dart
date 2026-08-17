import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// GPS Location Accuracy level during visit workflow.
enum GpsAccuracyLevel {
  good,
  weak,
  offline,
}

/// Status chip displaying live GPS accuracy and location fix staleness (Phase 5.1.3).
class GpsStatusChip extends StatelessWidget {
  const GpsStatusChip({
    super.key,
    this.accuracy = GpsAccuracyLevel.good,
    this.accuracyMeters,
    this.lastFixAge,
    this.stalenessThreshold = const Duration(seconds: 30),
    this.onTap,
  });

  final GpsAccuracyLevel accuracy;
  final double? accuracyMeters;
  final Duration? lastFixAge;
  final Duration stalenessThreshold;
  final VoidCallback? onTap;

  bool get isStale => lastFixAge != null && lastFixAge! > stalenessThreshold;

  @override
  Widget build(BuildContext context) {
    final effectiveAccuracy = isStale ? GpsAccuracyLevel.weak : accuracy;

    final (label, color, bgColor, icon) = switch (effectiveAccuracy) {
      GpsAccuracyLevel.good => ('GPS: Good', AppColors.healthGreen, AppColors.healthGreenLight.withAlpha(80), Icons.gps_fixed),
      GpsAccuracyLevel.weak => (isStale ? 'GPS: Stale Fix' : 'GPS: Weak', const Color(0xFFD97706), const Color(0xFFFEF3C7), Icons.gps_not_fixed),
      GpsAccuracyLevel.offline => ('GPS: Offline', AppColors.emergencyRed, AppColors.emergencyRedBg, Icons.gps_off),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s + 2, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              accuracyMeters != null ? '$label (${accuracyMeters!.toInt()}m)' : label,
              style: AppTextStyles.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
