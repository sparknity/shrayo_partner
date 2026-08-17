import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Spacing, Radius, and Elevation tokens for the Caregiver App.
abstract class AppSpacing {
  // Numeric Spacing Tokens
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Radius Tokens
  static const double radiusCard = 16.0;
  static const double radiusPill = 999.0;

  // BorderRadius Constants
  static final BorderRadius cardRadius = BorderRadius.circular(radiusCard);
  static final BorderRadius pillRadius = BorderRadius.circular(radiusPill);

  // EdgeInsets Convenience Helpers
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingS = EdgeInsets.all(s);
  static const EdgeInsets paddingM = EdgeInsets.all(m);
  static const EdgeInsets paddingL = EdgeInsets.all(l);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // Card Elevation & Soft Shadow
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: AppColors.black.withAlpha(10), // ~4% opacity soft shadow
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];
}
