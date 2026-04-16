import 'package:flutter/widgets.dart';
import 'package:easy_quote/ui/primitives/pressable.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? color;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      padding: const EdgeInsets.all(8),
      child: Icon(icon, size: size, color: color),
    );
  }
}
