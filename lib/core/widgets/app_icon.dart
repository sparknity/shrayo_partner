import 'package:flutter/material.dart';

/// Standard icon widget for the Caregiver App using PNG assets exclusively.
/// Supports resolution-aware asset variants (@1x, @2x, @3x).
class AppIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? tint;

  const AppIcon(
    this.assetPath, {
    super.key,
    this.size = 24,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );

    if (tint == null) return image;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(tint!, BlendMode.srcIn),
      child: image,
    );
  }
}
