import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Button visual variant options.
enum AppButtonVariant { primary, secondary, outline, text, emergency }

/// Button size options.
enum AppButtonSize { small, medium, large }

/// Primary button component with built-in submit-lock and loading state support.
///
/// **Submit-Lock (Phase 5.1.1 / 26B.4)**:
/// When [onPressed] returns a [Future], the button automatically locks itself and shows
/// a loading spinner until the Future completes. This structural protection prevents
/// accidental duplicate executions of irreversible actions (Check-In, Emergency Escalation, etc.).
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.height,
  });

  /// The button label text.
  final String label;

  /// Callback executed on press. Can return a [Future] to activate structural submit-lock.
  final FutureOr<void> Function()? onPressed;

  /// Visual variant of the button.
  final AppButtonVariant variant;

  /// Size metric for padding and height.
  final AppButtonSize size;

  /// Explicit loading override flag.
  final bool isLoading;

  /// Explicit disabled state override flag.
  final bool isDisabled;

  /// Optional leading icon.
  final Widget? icon;

  /// Optional explicit width override.
  final double? width;

  /// Optional explicit height override.
  final double? height;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isSubmitting = false;

  bool get _effectiveLoading => widget.isLoading || _isSubmitting;
  bool get _effectiveDisabled =>
      widget.isDisabled || widget.onPressed == null || _effectiveLoading;

  Future<void> _handleTap() async {
    if (_effectiveDisabled || widget.onPressed == null) return;

    final result = widget.onPressed!();
    if (result is Future) {
      if (mounted) {
        setState(() {
          _isSubmitting = true;
        });
      }
      try {
        await result;
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultHeight = switch (widget.size) {
      AppButtonSize.small => 36.0,
      AppButtonSize.medium => 48.0,
      AppButtonSize.large => 56.0,
    };

    final contentPadding = switch (widget.size) {
      AppButtonSize.small => const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      AppButtonSize.medium => const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      AppButtonSize.large => const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.m,
      ),
    };

    final textStyle = switch (widget.size) {
      AppButtonSize.small => AppTextStyles.labelMedium,
      AppButtonSize.medium => AppTextStyles.labelLarge.copyWith(
        fontWeight: FontWeight.w600,
      ),
      AppButtonSize.large => AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.w600,
      ),
    };

    final backgroundColor = _getBackgroundColor();
    final foregroundColor = _getForegroundColor();
    final borderSide = _getBorderSide();

    return SizedBox(
      width: widget.width,
      height: widget.height ?? defaultHeight,
      child: Material(
        color: backgroundColor,
        borderRadius: borderSide == null ? BorderRadius.circular(AppSpacing.radiusCard / 2) : null,
        shape: borderSide != null
            ? RoundedRectangleBorder(
                side: borderSide,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
              )
            : null,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _effectiveDisabled ? null : _handleTap,
          splashColor: foregroundColor.withAlpha(25),
          highlightColor: foregroundColor.withAlpha(12),
          child: Padding(
            padding: contentPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_effectiveLoading) ...[
                  SizedBox(
                    width: widget.size == AppButtonSize.small ? 14 : 18,
                    height: widget.size == AppButtonSize.small ? 14 : 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        foregroundColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                ] else if (widget.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      color: foregroundColor,
                      size: widget.size == AppButtonSize.small ? 16 : 20,
                    ),
                    child: widget.icon!,
                  ),
                  const SizedBox(width: AppSpacing.s),
                ],
                Text(
                  widget.label,
                  style: textStyle.copyWith(color: foregroundColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (_effectiveDisabled) {
      return AppColors.borderDivider.withAlpha(80);
    }
    return switch (widget.variant) {
      AppButtonVariant.primary => AppColors.primaryBlue,
      AppButtonVariant.secondary => AppColors.surfaceCard,
      AppButtonVariant.outline => AppColors.transparent,
      AppButtonVariant.text => AppColors.transparent,
      AppButtonVariant.emergency => AppColors.emergencyRed,
    };
  }

  Color _getForegroundColor() {
    if (_effectiveDisabled) {
      return AppColors.textSecondary.withAlpha(120);
    }
    return switch (widget.variant) {
      AppButtonVariant.primary => AppColors.white,
      AppButtonVariant.secondary => AppColors.textPrimary,
      AppButtonVariant.outline => AppColors.primaryBlue,
      AppButtonVariant.text => AppColors.primaryBlue,
      AppButtonVariant.emergency => AppColors.white,
    };
  }

  BorderSide? _getBorderSide() {
    if (widget.variant == AppButtonVariant.outline) {
      final color = _effectiveDisabled
          ? AppColors.borderDivider.withAlpha(100)
          : AppColors.primaryBlue;
      return BorderSide(color: color, width: 1.5);
    }
    return null;
  }
}
