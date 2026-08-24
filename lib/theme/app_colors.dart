import 'package:flutter/material.dart';

/// Baskt's color palette: navy blue and white.
///
/// NOTE: placeholder values until the Claude Design file is imported and
/// these are matched exactly to the source design.
class AppColors {
  AppColors._();

  // Navy shades - primary brand color.
  static const Color navy = Color(0xFF16233F);
  static const Color navyDark = Color(0xFF0E1730);
  static const Color navyLight = Color(0xFF2C3D63);

  // Neutrals.
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF6F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE3E6EE);

  static const Color textPrimary = Color(0xFF14213D);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnNavy = Color(0xFFFFFFFF);

  // Status colors, used for order tracking badges.
  static const Color success = Color(0xFF2E9B5C);
  static const Color warning = Color(0xFFE0A32C);
  static const Color error = Color(0xFFD64545);
  static const Color info = Color(0xFF3B6FE0);
}
