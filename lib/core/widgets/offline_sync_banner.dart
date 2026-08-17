import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Persistent banner for offline status & pending sync queue items (Section 5.2).
class OfflineSyncBanner extends StatelessWidget {
  const OfflineSyncBanner({
    super.key,
    required this.isOffline,
    required this.pendingItemCount,
    this.onSyncPressed,
  });

  final bool isOffline;
  final int pendingItemCount;
  final VoidCallback? onSyncPressed;

  @override
  Widget build(BuildContext context) {
    if (!isOffline && pendingItemCount == 0) {
      return const SizedBox.shrink();
    }

    final (message, bgColor, fgColor, icon) = isOffline
        ? ('You are offline. Changes saved locally.', const Color(0xFFFEF3C7), const Color(0xFFD97706), Icons.wifi_off)
        : ('$pendingItemCount item${pendingItemCount > 1 ? 's' : ''} pending sync', AppColors.primaryBlueLight.withAlpha(50), AppColors.primaryBlue, Icons.cloud_upload_outlined);

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          children: [
            Icon(icon, size: 18, color: fgColor),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.labelSmall.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (onSyncPressed != null && !isOffline && pendingItemCount > 0)
              InkWell(
                onTap: onSyncPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                  child: Text(
                    'Sync Now',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: fgColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
