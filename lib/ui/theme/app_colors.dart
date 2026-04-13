import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  // Backgrounds
  final Color background;
  final Color surface;
  final Color surfaceMuted;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // Borders
  final Color border;
  final Color borderStrong;

  // Text Buttons (legacy)
  final Color primaryTextButton;
  final Color secondaryTextButton;
  final Color dangerTextButton;
  final Color ghostTextButton;
  final Color linkTextButton;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderStrong,
    required this.primaryTextButton,
    required this.secondaryTextButton,
    required this.dangerTextButton,
    required this.ghostTextButton,
    required this.linkTextButton,
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
    Color? primaryTextButton,
    Color? secondaryTextButton,
    Color? dangerTextButton,
    Color? ghostTextButton,
    Color? linkTextButton,
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
      primaryTextButton: primaryTextButton ?? this.primaryTextButton,
      secondaryTextButton: secondaryTextButton ?? this.secondaryTextButton,
      dangerTextButton: dangerTextButton ?? this.dangerTextButton,
      ghostTextButton: ghostTextButton ?? this.ghostTextButton,
      linkTextButton: linkTextButton ?? this.linkTextButton,
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
      primaryTextButton: Color.lerp(
        primaryTextButton,
        other.primaryTextButton,
        t,
      )!,
      secondaryTextButton: Color.lerp(
        secondaryTextButton,
        other.secondaryTextButton,
        t,
      )!,
      dangerTextButton: Color.lerp(
        dangerTextButton,
        other.dangerTextButton,
        t,
      )!,
      ghostTextButton: Color.lerp(ghostTextButton, other.ghostTextButton, t)!,
      linkTextButton: Color.lerp(linkTextButton, other.linkTextButton, t)!,
    );
  }
}
