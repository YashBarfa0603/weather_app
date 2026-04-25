import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/forecast_model.dart';
import 'package:weather_app/widgets/glass_card.dart';

/// Horizontal scrolling hourly forecast strip
class HourlyForecast extends StatelessWidget {
  final List<ForecastItem> items;

  const HourlyForecast({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(Icons.schedule, size: 16, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                'HOURLY FORECAST',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.8,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isNow = index == 0;

              return GlassCard(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                opacity: isNow ? 0.2 : 0.1,
                borderRadius: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isNow ? 'Now' : DateFormat('HH:mm').format(item.dateTime),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isNow
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isNow ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    Text(
                      item.weatherEmoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                    Text(
                      '${item.temp.round()}°',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
