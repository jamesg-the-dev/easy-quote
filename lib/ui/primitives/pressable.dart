import 'package:flutter/widgets.dart';

class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const Pressable({super.key, required this.child, this.onTap, this.padding});

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!mounted) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _pressed ? 0.6 : 1,
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: widget.child,
        ),
      ),
    );
  }
}
