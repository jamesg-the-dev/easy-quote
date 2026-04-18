import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  // 🌐 Base surfaces
  final Color background;
  final Color surface;
  final Color surfaceMuted;

  // 📝 Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // 📏 Borders
  final Color border;
  final Color borderStrong;

  final Color inputHint;
  final Color inputBorder;
  final Color inputFocusedBorder;

  // 🚨 Semantic
  final Color primary;
  final Color danger;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderStrong,
    required this.primary,
    required this.danger,
    required this.inputHint,
    required this.inputBorder,
    required this.inputFocusedBorder,
  });

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? borderStrong,
    Color? primary,
    Color? danger,
    Color? inputHint,
    Color? inputBorder,
    Color? inputFocusedBorder,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      primary: primary ?? this.primary,
      danger: danger ?? this.danger,
      inputBorder: inputBorder ?? this.inputBorder,
      inputFocusedBorder: inputFocusedBorder ?? this.inputFocusedBorder,
      inputHint: inputHint ?? this.inputHint,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputFocusedBorder: Color.lerp(
        inputFocusedBorder,
        other.inputFocusedBorder,
        t,
      )!,
      inputHint: Color.lerp(inputHint, other.inputHint, t)!,
    );
  }
}
