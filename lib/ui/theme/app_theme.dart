import 'package:easy_quote/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    const colors = AppColors(
      // Backgrounds
      background: Color(0xFFFAFAFA),
      surface: Color(0xFFFFFFFF),
      surfaceMuted: Color(0xFFF4F4F5),

      // Text
      textPrimary: Color(0xFF1C1C1E),
      textSecondary: Color.fromARGB(255, 112, 112, 117),
      textMuted: Color(0xFF9A9AA3),

      // Borders
      border: Color(0xFFE5E5E7),
      borderStrong: Color(0xFFD4D4D8),

      // Input
      inputHint: Color(0xFFD1D5DB),
      inputBorder: Color(0xFFE5E5E7),
      inputFocusedBorder: Color(0xFF2563EB),
      primary: Color(0xFF2563EB),

      // Semantic
      danger: Color(0xFFEF4444),
    );

    return ThemeData(
      useMaterial3: false,

      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        error: colors.danger,
      ),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: colors.inputHint),
      ),

      splashFactory: NoSplash.splashFactory,
      textTheme: AppTypography.textTheme,

      extensions: [colors],
    );
  }
}
