import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../visit_workflow/domain/visit_workflow_stage.dart';

/// Persistent "Current Visit" Resume Banner (Section 6.2).
///
/// Displayed in [AppShell] whenever a caregiver has an active in-progress visit
/// and is navigating on tabs outside the visit workflow screens.
class CurrentVisitBanner extends StatelessWidget {
  const CurrentVisitBanner({
    super.key,
    required this.stage,
    required this.visitId,
    this.patientName = 'Eleanor Vance',
    this.patientAvatarUrl,
    this.onTap,
  });

  final VisitWorkflowStage stage;
  final String visitId;
  final String patientName;
  final String? patientAvatarUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (!stage.isVisitInProgress) {
      return const SizedBox.shrink();
    }

    final targetRoute = stage.routePath(visitId);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: AppColors.textNavyDeep,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else if (targetRoute != null) {
              context.go(targetRoute);
            }
          },
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s + 2,
            ),
            child: Row(
              children: [
                AppAvatar(
                  name: patientName,
                  imageUrl: patientAvatarUrl,
                  size: AppAvatarSize.small,
                  backgroundColor: AppColors.white.withAlpha(40),
                  textColor: AppColors.white,
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.healthGreenLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'VISIT IN PROGRESS',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.healthGreenLight,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$patientName • ${stage.stepLabel}',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Resume',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_forward,
                        size: 12,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
