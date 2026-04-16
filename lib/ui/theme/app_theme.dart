import 'package:easy_quote/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    const primary = Color(0xFF2563EB);

    const colors = AppColors(
      // Backgrounds
      background: Color(0xFFFAFAFA),
      surface: Color(0xFFFFFFFF),
      surfaceMuted: Color(0xFFF4F4F5),

      // Text
      textPrimary: Color(0xFF111113),
      textSecondary: Color.fromARGB(255, 112, 112, 117),
      textMuted: Color(0xFF9A9AA3),

      // Borders
      border: Color(0xFFE5E5E7),
      borderStrong: Color(0xFFD4D4D8),

      // Semantic
      danger: Color(0xFFDC2626),
    );

    return ThemeData(
      useMaterial3: false,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        error: colors.danger,
      ),

      splashFactory: NoSplash.splashFactory,
      textTheme: AppTypography.textTheme,

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: colors.inputHint),

        border: InputBorder.none,

        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.inputBorder),
        ),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.inputFocusedBorder),
        ),

        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.danger),
        ),

        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.danger),
        ),

        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),

      extensions: [colors],
    );
  }
}
