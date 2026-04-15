import 'package:flutter/material.dart';
import 'package:easy_quote/ui/primitives/pressable.dart';

enum ButtonVariant { primary, secondary, danger, ghost, link }

enum ButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool disabled;
  final bool loading;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.disabled = false,
    this.loading = false,
    this.leftIcon,
    this.rightIcon,
    this.fullWidth = false,
  });

  bool get _isDisabled => disabled || loading || onTap == null;

  @override
  Widget build(BuildContext context) {
    final style = _getStyle(context);

    return Pressable(
      onTap: _isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: fullWidth ? double.infinity : null,
        height: style.height,
        padding: style.padding,
        decoration: BoxDecoration(
          color: style.bg,
          borderRadius: BorderRadius.circular(8),
          border: style.border,
        ),
        child: Opacity(
          opacity: _isDisabled ? 0.5 : 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (loading) ...[
                SizedBox(
                  width: style.iconSize,
                  height: style.iconSize,
                  child: _Spinner(color: style.fg),
                ),
                const SizedBox(width: 8),
              ] else if (leftIcon != null) ...[
                IconTheme(
                  data: IconThemeData(size: style.iconSize, color: style.fg),
                  child: leftIcon!,
                ),
                const SizedBox(width: 8),
              ],

              Text(
                label,
                style: TextStyle(
                  color: style.fg,
                  fontSize: style.fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),

              if (!loading && rightIcon != null) ...[
                const SizedBox(width: 8),
                IconTheme(
                  data: IconThemeData(size: style.iconSize, color: style.fg),
                  child: rightIcon!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  _ButtonStyle _getStyle(BuildContext context) {
    final base = _baseSize();

    switch (variant) {
      case ButtonVariant.primary:
        return base.copyWith(fg: Colors.white, bg: Colors.black);

      case ButtonVariant.secondary:
        return base.copyWith(fg: Colors.black, bg: Colors.grey.shade200);

      case ButtonVariant.danger:
        return base.copyWith(fg: Colors.white, bg: Colors.red);

      case ButtonVariant.ghost:
        return base.copyWith(fg: Colors.black, bg: Colors.transparent);

      case ButtonVariant.link:
        return base.copyWith(
          fg: Colors.blue,
          bg: Colors.transparent,
          padding: EdgeInsets.zero,
          height: null,
        );
    }
  }

  _ButtonStyle _baseSize() {
    switch (size) {
      case ButtonSize.sm:
        return _ButtonStyle(
          fontSize: 12,
          iconSize: 14,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          height: 32,
        );

      case ButtonSize.lg:
        return _ButtonStyle(
          fontSize: 16,
          iconSize: 18,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          height: 48,
        );

      case ButtonSize.md:
      default:
        return _ButtonStyle(
          fontSize: 14,
          iconSize: 16,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          height: 40,
        );
    }
  }
}

class _ButtonStyle {
  final double fontSize;
  final double iconSize;
  final EdgeInsets padding;
  final double? height;
  final Color fg;
  final Color bg;
  final BoxBorder? border;

  _ButtonStyle({
    required this.fontSize,
    required this.iconSize,
    required this.padding,
    this.height,
    this.fg = Colors.black,
    this.bg = Colors.transparent,
    this.border,
  });

  _ButtonStyle copyWith({
    Color? fg,
    Color? bg,
    EdgeInsets? padding,
    double? height,
    BoxBorder? border,
  }) {
    return _ButtonStyle(
      fontSize: fontSize,
      iconSize: iconSize,
      padding: padding ?? this.padding,
      height: height ?? this.height,
      fg: fg ?? this.fg,
      bg: bg ?? this.bg,
      border: border ?? this.border,
    );
  }
}

class _Spinner extends StatefulWidget {
  final Color color;

  const _Spinner({required this.color});

  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat();

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SizedBox(
        width: 16,
        height: 16,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border(
              top: BorderSide(width: 2, color: Colors.transparent),
              right: const BorderSide(width: 2, color: Colors.transparent),
              bottom: const BorderSide(width: 2, color: Colors.transparent),
              left: const BorderSide(width: 2, color: Colors.transparent),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
