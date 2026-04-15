import 'package:flutter/material.dart';

enum AppLogoVariant { defaultVariant, withText }

class AppLogo extends StatelessWidget {
  final AppLogoVariant variant;

  const AppLogo({super.key, this.variant = AppLogoVariant.defaultVariant});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFD4D4D8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFA1A1A6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        if (variant == AppLogoVariant.withText) const SizedBox(width: 8),
        if (variant == AppLogoVariant.withText)
          const Text(
            'EasyQuote',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
      ],
    );
  }
}
