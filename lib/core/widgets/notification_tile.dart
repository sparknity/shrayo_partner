import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Notification visual category types.
enum NotificationCategory {
  alert,
  visitUpdate,
  reminder,
  system,
}

/// Notification list row item.
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.category = NotificationCategory.system,
    this.onTap,
  });

  final String title;
  final String body;
  final String timestamp;
  final bool isRead;
  final NotificationCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor, iconBg) = switch (category) {
      NotificationCategory.alert => (Icons.error_outline, AppColors.emergencyRed, AppColors.emergencyRedBg),
      NotificationCategory.visitUpdate => (Icons.assignment_outlined, AppColors.primaryBlue, AppColors.primaryBlueLight.withAlpha(40)),
      NotificationCategory.reminder => (Icons.alarm, const Color(0xFFD97706), const Color(0xFFFEF3C7)),
      NotificationCategory.system => (Icons.notifications_none, AppColors.textSecondary, AppColors.surfaceCard),
    };

    return Material(
      color: isRead ? AppColors.white : AppColors.primaryBlueLight.withAlpha(12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
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
                              fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: AppSpacing.s),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      body,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs + 2),
                    Text(
                      timestamp,
                      style: AppTextStyles.timestamp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
