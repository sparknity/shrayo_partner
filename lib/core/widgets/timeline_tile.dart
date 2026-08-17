import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Vertical timeline tile component for Health Timeline, Attendance History, Emergency History.
class TimelineTile extends StatelessWidget {
  const TimelineTile({
    super.key,
    required this.title,
    required this.timestamp,
    this.description,
    this.icon = Icons.circle,
    this.iconColor = AppColors.primaryBlue,
    this.lineColor = AppColors.borderDivider,
    this.isFirst = false,
    this.isLast = false,
    this.extraContent,
  });

  final String title;
  final String timestamp;
  final String? description;
  final IconData icon;
  final Color iconColor;
  final Color lineColor;
  final bool isFirst;
  final bool isLast;
  final Widget? extraContent;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(child: Container(width: 2, color: lineColor))
                else
                  const Expanded(child: SizedBox()),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 12, color: iconColor),
                ),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: lineColor))
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        timestamp,
                        style: AppTextStyles.timestamp,
                      ),
                    ],
                  ),
                  if (description != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (extraContent != null) ...[
                    const SizedBox(height: AppSpacing.s),
                    extraContent!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
