import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Preset sizes for [AppAvatar].
enum AppAvatarSize {
  small(32.0),
  medium(48.0),
  large(64.0),
  extraLarge(88.0);

  const AppAvatarSize(this.dimension);
  final double dimension;
}

/// Profile avatar widget with automatic initials fallback, cached network image loading,
/// and optional online presence indicator badge.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppAvatarSize.medium,
    this.customSize,
    this.isOnline,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  final String? imageUrl;
  final String? name;
  final AppAvatarSize size;
  final double? customSize;
  final bool? isOnline;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  double get _dimension => customSize ?? size.dimension;

  String get _initials {
    if (name == null || name!.trim().isEmpty) return '?';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length > 2 ? 2 : parts.first.length).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primaryBlueLight.withAlpha(50);
    final fg = textColor ?? AppColors.primaryBlue;
    final fontSize = _dimension * 0.4;

    Widget avatarChild;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarChild = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: _dimension,
        height: _dimension,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: bg,
          child: Center(
            child: SizedBox(
              width: _dimension * 0.3,
              height: _dimension * 0.3,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildInitialsFallback(bg, fg, fontSize),
      );
    } else {
      avatarChild = _buildInitialsFallback(bg, fg, fontSize);
    }

    Widget content = ClipOval(child: avatarChild);

    if (isOnline != null) {
      final badgeSize = (_dimension * 0.28).clamp(8.0, 18.0);
      content = Stack(
        children: [
          content,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: isOnline! ? AppColors.healthGreen : AppColors.borderDivider,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }

  Widget _buildInitialsFallback(Color bg, Color fg, double fontSize) {
    return Container(
      width: _dimension,
      height: _dimension,
      color: bg,
      child: Center(
        child: Text(
          _initials,
          style: AppTextStyles.labelLarge.copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}
