import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1a1a2e), // Deep dark blue
                  const Color(0xFF16213e), // Navy
                  const Color(0xFF0f3460), // Dark blue
                ]
              : [
                  const Color(0xFF667eea), // Vibrant blue-purple
                  const Color(0xFF764ba2), // Deep purple
                  const Color(0xFFf093fb), // Soft pink
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
