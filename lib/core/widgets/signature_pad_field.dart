import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Canvas field wrapping `signature` package for patient sign-off and consent (Phase 5.1.4).
class SignaturePadField extends StatefulWidget {
  const SignaturePadField({
    super.key,
    this.title = 'Patient / Guardian Signature',
    this.height = 180.0,
    this.onSignatureCaptured,
    this.readOnly = false,
  });

  final String title;
  final double height;
  final ValueChanged<Uint8List?>? onSignatureCaptured;
  final bool readOnly;

  @override
  State<SignaturePadField> createState() => _SignaturePadFieldState();
}

class _SignaturePadFieldState extends State<SignaturePadField> {
  late final SignatureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 3,
      penColor: AppColors.textPrimary,
      exportBackgroundColor: Colors.transparent,
    );
    _controller.addListener(_handleSignatureChange);
  }

  void _handleSignatureChange() async {
    if (widget.onSignatureCaptured != null) {
      if (_controller.isEmpty) {
        widget.onSignatureCaptured!(null);
      } else {
        final pngBytes = await _controller.toPngBytes();
        widget.onSignatureCaptured!(pngBytes);
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleSignatureChange);
    _controller.dispose();
    super.dispose();
  }

  void _clearSignature() {
    _controller.clear();
    widget.onSignatureCaptured?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            if (!widget.readOnly)
              TextButton.icon(
                onPressed: _clearSignature,
                icon: const Icon(Icons.refresh, size: 16, color: AppColors.emergencyRed),
                label: Text(
                  'Clear',
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.emergencyRed),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.surfaceBackground,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
            border: Border.all(color: AppColors.borderDivider),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Signature(
                controller: _controller,
                height: widget.height,
                backgroundColor: AppColors.surfaceBackground,
              ),
              Positioned(
                bottom: AppSpacing.s,
                left: AppSpacing.m,
                right: AppSpacing.m,
                child: Container(
                  height: 1,
                  color: AppColors.borderDivider.withAlpha(100),
                ),
              ),
              Positioned(
                bottom: AppSpacing.s + 4,
                left: AppSpacing.m,
                child: Text(
                  'Sign on the line above',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary.withAlpha(120)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
