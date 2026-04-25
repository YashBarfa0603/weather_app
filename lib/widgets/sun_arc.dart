import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_app/theme.dart';
import 'package:weather_app/widgets/glass_card.dart';

/// Sunrise/Sunset arc visualization with current sun position
class SunArcWidget extends StatelessWidget {
  final int sunrise;
  final int sunset;
  final int timezone;

  const SunArcWidget({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.timezone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sunriseTime = DateTime.fromMillisecondsSinceEpoch(sunrise * 1000, isUtc: true)
        .add(Duration(seconds: timezone));
    final sunsetTime = DateTime.fromMillisecondsSinceEpoch(sunset * 1000, isUtc: true)
        .add(Duration(seconds: timezone));
    final now = DateTime.now().toUtc().add(Duration(seconds: timezone));

    final totalDaylight = sunsetTime.difference(sunriseTime).inMinutes;
    final elapsed = now.difference(sunriseTime).inMinutes;
    final progress = (elapsed / totalDaylight).clamp(0.0, 1.0);
    final isDaytime = now.isAfter(sunriseTime) && now.isBefore(sunsetTime);

    final sunriseStr = '${sunriseTime.hour.toString().padLeft(2, '0')}:${sunriseTime.minute.toString().padLeft(2, '0')}';
    final sunsetStr = '${sunsetTime.hour.toString().padLeft(2, '0')}:${sunsetTime.minute.toString().padLeft(2, '0')}';

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_twilight, size: 16, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                'SUN CYCLE',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.8,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: CustomPaint(
              size: const Size(double.infinity, 100),
              painter: _SunArcPainter(
                progress: isDaytime ? progress : 0,
                isDaytime: isDaytime,
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🌅 Sunrise', style: theme.textTheme.bodySmall),
                  Text(sunriseStr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('🌇 Sunset', style: theme.textTheme.bodySmall),
                  Text(sunsetStr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SunArcPainter extends CustomPainter {
  final double progress;
  final bool isDaytime;
  final bool isDark;

  _SunArcPainter({
    required this.progress,
    required this.isDaytime,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2.2;

    // Draw track arc
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.black.withValues(alpha: 0.08);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      trackPaint,
    );

    // Draw dashed horizon line
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.06);

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      dashPaint,
    );

    if (!isDaytime) return;

    // Draw progress arc with gradient
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          SkyCastColors.amber,
          SkyCastColors.primary,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * progress,
      false,
      progressPaint,
    );

    // Draw sun position
    final angle = pi + pi * progress;
    final sunX = center.dx + radius * cos(angle);
    final sunY = center.dy + radius * sin(angle);

    // Sun glow
    final glowPaint = Paint()
      ..color = SkyCastColors.amber.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(sunX, sunY), 14, glowPaint);

    // Sun body
    final sunPaint = Paint()..color = SkyCastColors.amber;
    canvas.drawCircle(Offset(sunX, sunY), 8, sunPaint);

    // Sun core
    final corePaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    canvas.drawCircle(Offset(sunX, sunY), 4, corePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
