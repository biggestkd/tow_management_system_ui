import 'package:flutter/material.dart';

/// Centralized color palette for the entire app.
/// Use semantic names instead of hardcoding raw color values in widgets.
class AppColors {
  AppColors._(); // private constructor — prevents instantiation

  // ------------------------------------------------------------
  // 🎨 Brand Palette
  // ------------------------------------------------------------
  static const Color primary = Color(0xFF1E88E5); // Blue 600
  static const Color primaryLight = Color(0xFF6AB7FF); // Blue 300
  static const Color primaryDark = Color(0xFF005CB2); // Blue 800

  static const Color secondary = Color(0xFFFFA000); // Amber 700
  static const Color secondaryLight = Color(0xFFFFD149); // Amber 400
  static const Color secondaryDark = Color(0xFFC67100); // Amber 900

  static const Color accent = Color(0xFF00BCD4); // Cyan accent for highlights

  // ------------------------------------------------------------
  // 🌗 Neutrals
  // ------------------------------------------------------------
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // ------------------------------------------------------------
  // ✅ Status / Feedback Colors
  // ------------------------------------------------------------
  static const Color success = Color(0xFF43A047); // Green 600
  static const Color warning = Color(0xFFFBC02D); // Yellow 700
  static const Color error = Color(0xFFE53935);   // Red 600
  static const Color info = Color(0xFF1E88E5);    // Blue 600

  // ------------------------------------------------------------
  // 🧱 UI Surfaces
  // ------------------------------------------------------------
  static const Color background = Color(0xFFF5F7FB); // Light gray app bg
  static const Color surface = Colors.white;         // Card/Container bg
  static const Color border = Color(0xFFE0E0E0);     // Divider / outline

  // ------------------------------------------------------------
  // ✍️ Text Colors
  // ------------------------------------------------------------
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF4D4D4D);
  static const Color textDisabled = Color(0xFF9E9E9E);

  // ------------------------------------------------------------
  // 🔘 Interactive States
  // ------------------------------------------------------------
  static const Color focus = Color(0xFF1565C0); // darker blue
  static const Color hover = Color(0xFFE3F2FD);
  static const Color pressed = Color(0xFFBBDEFB);
  static const Color disabled = Color(0xFFBDBDBD);
}
