import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/theme.dart';

/// glassmorphic card with backdrop blur effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final double opacity;
  final double blurAmount;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.opacity = 0.12,
    this.blurAmount = 20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
            child: Container(
              padding: padding ?? const EdgeInsets.all(16),
              decoration: GlassDecoration.card(
                isDark: isDark,
                opacity: opacity,
                radius: borderRadius,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
