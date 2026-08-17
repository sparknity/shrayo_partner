import 'package:flutter/material.dart';

/// App color tokens for the Caregiver / Care Manager App.
/// 
/// Note: Inherited default token values mirror the platform palette pending
/// design sign-off on caregiver-specific frames.
abstract class AppColors {
  // Primary Blue Palette
  static const Color primaryBlue = Color(0xFF004AC6);
  static const Color primaryBlueMid = Color(0xFF2563EB);
  static const Color primaryBlueLight = Color(0xFF4D81E7);

  // Health Green Palette
  static const Color healthGreen = Color(0xFF006C49);
  static const Color healthGreenLight = Color(0xFF6CF8BB);
  static const Color semanticSuccess = Color(0xFF006C49);

  // Emergency Red Palette
  static const Color emergencyRed = Color(0xFFBA1A1A);
  static const Color emergencyRedBg = Color(0xFFFEF2F2);

  // Typography Colors
  static const Color textPrimary = Color(0xFF191C1E);
  static const Color textNavyDeep = Color(0xFF021433);
  static const Color textSecondary = Color(0xFF434655);

  // Surface & Background Colors
  static const Color surfaceBackground = Color(0xFFF7F9FB);
  static const Color surfaceCard = Color(0xFFF2F4F6);

  // Borders & Dividers
  static const Color borderDivider = Color(0xFFC3C6D7);

  // Common Utility Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
}
