import 'package:easy_quote/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

const MaterialColor softRed = MaterialColor(
  0xFFE5484D, // primary (500)
  <int, Color>{
    50: Color(0xFFFFF5F5),
    100: Color(0xFFFFE3E3),
    200: Color(0xFFFFC9C9),
    300: Color(0xFFFFA8A8),
    400: Color(0xFFFF8787),
    500: Color(0xFFE5484D),
    600: Color(0xFFD13F44),
    700: Color(0xFFB9383C),
    800: Color(0xFFA03135),
    900: Color(0xFF872A2E),
  },
);

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        error: softRed,
      ),
      splashFactory: NoSplash.splashFactory,
      textTheme: AppTypography.textTheme,
      extensions: const [
        AppColors(
          background: Color(0xFFFAFAFA),
          surface: Color(0xFFFFFFFF),
          surfaceMuted: Color(0xFFF4F4F5),
          textPrimary: Color(0xFF111113),
          textSecondary: Color.fromARGB(255, 112, 112, 117),
          textMuted: Color(0xFF9A9AA3),
          border: Color(0xFFE5E5E7),
          borderStrong: Color(0xFFD4D4D8),
          primaryTextButton: Color(0xFF1C1C1F),
          secondaryTextButton: Color(0xFF6B6B73),
          dangerTextButton: Color(0xFFDC2626),
          ghostTextButton: Color(0xFF1C1C1F),
          linkTextButton: Color(0xFF2A2A2F),
        ),
      ],
    );
  }
}
