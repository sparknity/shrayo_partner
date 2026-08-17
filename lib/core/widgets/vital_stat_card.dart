import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Severity status for vital metrics.
enum VitalStatus {
  normal,
  warning,
  critical,
  high,
}

/// Trend direction for vital metrics.
enum VitalTrend {
  up,
  down,
  stable,
}

/// Display card for vital statistics (Blood Pressure, Heart Rate, Temp, SpO2, etc.).
class VitalStatCard extends StatelessWidget {
  const VitalStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    this.status = VitalStatus.normal,
    this.timestamp,
    this.icon,
    this.trend,
    this.onTap,
  });

  final String title;
  final String value;
  final String unit;
  final VitalStatus status;
  final String? timestamp;
  final IconData? icon;
  final VitalTrend? trend;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusBgColor, statusLabel) = switch (status) {
      VitalStatus.normal => (AppColors.healthGreen, AppColors.healthGreenLight.withAlpha(50), 'Normal'),
      VitalStatus.warning => (const Color(0xFFD97706), const Color(0xFFFEF3C7), 'Warning'),
      VitalStatus.critical => (AppColors.emergencyRed, AppColors.emergencyRedBg, 'Critical'),
      VitalStatus.high => (AppColors.primaryBlue, AppColors.surfaceCard, 'Elevated'),
    };

    return Card(
      elevation: 0,
      color: AppColors.surfaceBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        side: const BorderSide(color: AppColors.borderDivider),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
                        ),
                        child: Icon(
                          icon ?? Icons.favorite_outline,
                          size: 18,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Text(
                        title,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    child: Text(
                      statusLabel,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
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
                    value,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    unit,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (trend != null) ...[
                    const Spacer(),
                    _buildTrendIcon(trend!),
                  ],
                ],
              ),
              if (timestamp != null) ...[
                const SizedBox(height: AppSpacing.s),
                Text(
                  timestamp!,
                  style: AppTextStyles.timestamp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendIcon(VitalTrend trend) {
    final (icon, color) = switch (trend) {
      VitalTrend.up => (Icons.trending_up, AppColors.emergencyRed),
      VitalTrend.down => (Icons.trending_down, AppColors.healthGreen),
      VitalTrend.stable => (Icons.trending_flat, AppColors.textSecondary),
    };

    return Icon(icon, size: 18, color: color);
  }
}
