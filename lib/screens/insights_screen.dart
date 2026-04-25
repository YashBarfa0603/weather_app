import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/model/forecast_model.dart';
import 'package:weather_app/theme.dart';
import 'package:weather_app/widgets/glass_card.dart';
import 'package:weather_app/widgets/temperature_chart.dart';
import 'package:weather_app/widgets/outfit_card.dart';

class InsightsScreen extends StatelessWidget {
  final WeatherModel weather;
  final ForecastModel forecast;

  const InsightsScreen({
    super.key,
    required this.weather,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: WeatherGradients.getGradient(weather.mainCondition, isDark),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            SkyCastColors.primary,
                            SkyCastColors.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'AI Insights',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              // AI Briefing
              Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ShaderMask(
                                shaderCallback: (b) => const LinearGradient(
                                  colors: [
                                    SkyCastColors.primary,
                                    SkyCastColors.secondary,
                                  ],
                                ).createShader(b),
                                child: Text(
                                  'AI WEATHER SUMMARY',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    letterSpacing: 0.8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            weather.aiBriefing,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Quick stats row
                          Row(
                            children: [
                              _quickStat(
                                weather.weatherEmoji,
                                '${weather.temperature.round()}°',
                                theme,
                              ),
                              const SizedBox(width: 16),
                              _quickStat('💧', '${weather.humidity}%', theme),
                              const SizedBox(width: 16),
                              _quickStat(
                                '💨',
                                '${weather.windSpeed.round()} m/s',
                                theme,
                              ),
                              const SizedBox(width: 16),
                              _quickStat(
                                '👁',
                                '${(weather.visibility / 1000).round()} km',
                                theme,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms)
                  .slideY(begin: 0.1),

              // Outfit Recommender
              const SizedBox(height: 28),
              OutfitCard(
                suggestions: weather.outfitSuggestions,
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

              // Activity Suggestions
              const SizedBox(height: 28),
              ActivityCard(
                activities: weather.activitySuggestions,
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

              // Weather Mood
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('🎭', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            'WEATHER MOOD',
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 0.8,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _moodItem(
                            _getMoodEmoji(),
                            _getMoodLabel(),
                            true,
                            theme,
                          ),
                          _moodItem(
                            _getEnergyEmoji(),
                            _getEnergyLabel(),
                            false,
                            theme,
                          ),
                          _moodItem(
                            _getComfortEmoji(),
                            _getComfortLabel(),
                            false,
                            theme,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

              // 5-Day Forecast Chart
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TemperatureChart(dailyForecast: forecast.daily),
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

              // Daily Forecast List
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'DAILY DETAILS',
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 0.8,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...forecast.daily.take(5).map((item) {
                      final dayName = _dayName(item.dateTime);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Text(
                                  dayName,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                item.weatherEmoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.description
                                      .split(' ')
                                      .map(
                                        (w) => w.isNotEmpty
                                            ? '${w[0].toUpperCase()}${w.substring(1)}'
                                            : w,
                                      )
                                      .join(' '),
                                  style: theme.textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${item.tempMax.round()}°',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                ' / ${item.tempMin.round()}°',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 400.ms),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickStat(String emoji, String value, ThemeData t) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: t.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _moodItem(String emoji, String label, bool isMain, ThemeData t) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: isMain ? 40 : 30)),
        const SizedBox(height: 6),
        Text(
          label,
          style: t.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  String _getMoodEmoji() {
    if (weather.mainCondition.toLowerCase() == 'clear') return '😊';
    if (weather.mainCondition.toLowerCase().contains('cloud')) return '😌';
    if (weather.mainCondition.toLowerCase().contains('rain')) return '🥱';
    if (weather.mainCondition.toLowerCase().contains('snow')) return '🤩';
    if (weather.mainCondition.toLowerCase().contains('thunder')) return '😨';
    return '😐';
  }

  String _getMoodLabel() {
    if (weather.mainCondition.toLowerCase() == 'clear') return 'Happy';
    if (weather.mainCondition.toLowerCase().contains('cloud')) return 'Calm';
    if (weather.mainCondition.toLowerCase().contains('rain')) return 'Cozy';
    if (weather.mainCondition.toLowerCase().contains('snow')) return 'Excited';
    return 'Neutral';
  }

  String _getEnergyEmoji() {
    if (weather.temperature > 30) return '🔋';
    if (weather.temperature > 20) return '⚡';
    if (weather.temperature > 10) return '🔌';
    return '🧊';
  }

  String _getEnergyLabel() {
    if (weather.temperature > 30) return 'Low Energy';
    if (weather.temperature > 20) return 'High Energy';
    if (weather.temperature > 10) return 'Moderate';
    return 'Hibernate';
  }

  String _getComfortEmoji() {
    if (weather.humidity > 80) return '😓';
    if (weather.humidity > 50) return '😊';
    return '🏜️';
  }

  String _getComfortLabel() {
    if (weather.humidity > 80) return 'Muggy';
    if (weather.humidity > 50) return 'Comfortable';
    return 'Dry';
  }

  String _dayName(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month) return 'Today';
    if (dt.day == now.day + 1 && dt.month == now.month) return 'Tmrw';
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dt.weekday - 1];
  }
}
