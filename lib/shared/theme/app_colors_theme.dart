import 'package:flutter/material.dart';

class AppColorsTheme {
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF1E40AF);
  static const Color accent = Color(0xFF10B981);

  static const Color headline = Color(0xFF1F2937);
  static const Color subtitle = Color(0xFF4B5563);
  static const Color bodytext = Color(0xFF6B7280);

  static const Color scaffold = Color(0xFFF9FAFB);
  static const Color secondaryScaffoldColor = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color lightBlue = Color(0xFF60A5FA);
  static const Color green = Color(0xFF34D399);
  static const Color yellow = Color(0xFFFBBF24);
  static const Color red = Color(0xFFF87171);
  static const Color pink = Color(0xFFEC4899);

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  static const Color inputFill = Color(0xFFF9FAFB);
  static const Color inputBorder = Color(0xFFD1D5DB);
  static const Color inputFocus = Color(0xFF2563EB);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );
}
