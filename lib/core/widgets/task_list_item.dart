import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_avatar.dart';

/// Task priority enum.
enum TaskPriority {
  low,
  medium,
  high,
}

/// Task row list item for caregiver task management (Section 5.2).
class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.title,
    required this.isCompleted,
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.assigneeName,
    this.assigneeAvatarUrl,
    this.onToggleCompleted,
    this.onTap,
  });

  final String title;
  final bool isCompleted;
  final String? dueDate;
  final TaskPriority priority;
  final String? assigneeName;
  final String? assigneeAvatarUrl;
  final ValueChanged<bool?>? onToggleCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (priorityLabel, priorityColor, priorityBg) = switch (priority) {
      TaskPriority.low => ('Low', AppColors.textSecondary, AppColors.surfaceCard),
      TaskPriority.medium => ('Medium', const Color(0xFFD97706), const Color(0xFFFEF3C7)),
      TaskPriority.high => ('High', AppColors.emergencyRed, AppColors.emergencyRedBg),
    };

    return Card(
      elevation: 0,
      color: isCompleted ? AppColors.surfaceCard.withAlpha(120) : AppColors.surfaceBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
        side: const BorderSide(color: AppColors.borderDivider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.s + 2),
          child: Row(
            children: [
              Checkbox(
                value: isCompleted,
                onChanged: onToggleCompleted,
                activeColor: AppColors.healthGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (dueDate != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(dueDate!, style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  priorityLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: priorityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (assigneeName != null || assigneeAvatarUrl != null) ...[
                const SizedBox(width: AppSpacing.s),
                AppAvatar(
                  name: assigneeName,
                  imageUrl: assigneeAvatarUrl,
                  size: AppAvatarSize.small,
                  customSize: 24,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
