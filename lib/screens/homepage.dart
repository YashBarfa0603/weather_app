import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/model/forecast_model.dart';
import 'package:weather_app/sevices/weather_servic.dart';
import 'package:weather_app/theme.dart';
import 'package:weather_app/widgets/glass_card.dart';
import 'package:weather_app/widgets/weather_metric_card.dart';
import 'package:weather_app/widgets/hourly_forecast.dart';
import 'package:weather_app/widgets/sun_arc.dart';
import 'package:weather_app/widgets/temperature_chart.dart';
import 'package:weather_app/screens/search_screen.dart';
import 'package:weather_app/screens/insights_screen.dart';

class Homepage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const Homepage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  final WeatherServices _weatherServices = WeatherServices();
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMsg = '';
  int _currentIndex = 0;

  WeatherModel? _weather;
  ForecastModel? _forecast;

  @override
  void initState() {
    super.initState();
    _loadWeather('Indore');
  }

  void _loadWeather(String city) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final results = await Future.wait([
        _weatherServices.fetchWeather(city),
        _weatherServices.fetchForecast(city),
      ]);

      setState(() {
        _weather = results[0] as WeatherModel;
        _forecast = results[1] as ForecastModel;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMsg = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeBody(),
          SearchScreen(
            onCitySelected: (city) {
              _loadWeather(city);
              setState(() => _currentIndex = 0);
            },
          ),
          if (_weather != null && _forecast != null)
            InsightsScreen(weather: _weather!, forecast: _forecast!)
          else
            const Center(child: Text('Load weather data first')),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeBody() {
    final isDark = widget.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: _weather != null
            ? WeatherGradients.getGradient(_weather!.mainCondition, isDark)
            : WeatherGradients.getGradient('', isDark),
      ),
      child: SafeArea(
        bottom: false,
        child: _isLoading
            ? _buildLoadingState()
            : _hasError
                ? _buildErrorState()
                : _weather != null
                    ? _buildWeatherContent()
                    : _buildLoadingState(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: SkyCastColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading weather...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😔', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(
              _errorMsg,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _loadWeather('Mumbai'),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: SkyCastColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    final weather = _weather!;
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode;

    return RefreshIndicator(
      onRefresh: () async {
        _loadWeather(weather.cityName);
      },
      color: SkyCastColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 18,
                      color: theme.colorScheme.onSurface),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${weather.cityName}, ${weather.country}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onToggleTheme,
                    icon: Icon(
                      isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

            const SizedBox(height: 20),
            Text(
              weather.weatherEmoji,
              style: const TextStyle(fontSize: 60),
            ).animate().scale(delay: 200.ms, duration: 500.ms),

            const SizedBox(height: 8),
            Text(
              '${weather.temperature.round()}°',
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

            const SizedBox(height: 4),
            Text(
              weather.description.split(' ').map((w) =>
                  w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : w
              ).join(' '),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

            const SizedBox(height: 4),
            Text(
              'Feels like ${weather.feelsLike.round()}°  •  H:${weather.tempMax.round()}°  L:${weather.tempMin.round()}°',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [SkyCastColors.primary, SkyCastColors.secondary],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Weather Brief',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: SkyCastColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            weather.aiBriefing,
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 600.ms, duration: 400.ms).slideY(begin: 0.1),

            const SizedBox(height: 28),
            if (_forecast != null)
              HourlyForecast(items: _forecast!.hourly)
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 400.ms),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 130,
                          child: WeatherMetricCard(
                            label: 'Wind',
                            value: '${weather.windSpeed.round()}',
                            unit: 'm/s ${weather.windDirection}',
                            icon: Icons.air,
                            iconColor: SkyCastColors.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 130,
                          child: WeatherMetricCard(
                            label: 'Humidity',
                            value: '${weather.humidity}',
                            unit: '%',
                            icon: Icons.water_drop_outlined,
                            iconColor: SkyCastColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 130,
                          child: WeatherMetricCard(
                            label: 'Pressure',
                            value: '${weather.pressure}',
                            unit: 'hPa',
                            icon: Icons.speed,
                            iconColor: SkyCastColors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 130,
                          child: WeatherMetricCard(
                            label: 'Visibility',
                            value: '${(weather.visibility / 1000).round()}',
                            unit: 'km',
                            icon: Icons.visibility_outlined,
                            iconColor: SkyCastColors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 130,
                          child: WeatherMetricCard(
                            label: 'Clouds',
                            value: '${weather.clouds}',
                            unit: '%',
                            icon: Icons.cloud_outlined,
                            iconColor: SkyCastColors.primaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 130,
                          child: WeatherMetricCard(
                            label: 'Feels Like',
                            value: '${weather.feelsLike.round()}°',
                            unit: _feelsLikeLabel(weather),
                            icon: Icons.thermostat_outlined,
                            iconColor: SkyCastColors.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 500.ms).slideY(begin: 0.05),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: SunArcWidget(
                sunrise: weather.sunrise,
                sunset: weather.sunset,
                timezone: weather.timezone,
              ),
            ).animate().fadeIn(delay: 900.ms, duration: 400.ms),

            if (_forecast != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: RainProbabilityChart(items: _forecast!.hourly),
              ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
            ],

            if (_forecast != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: TemperatureChart(dailyForecast: _forecast!.daily),
              ).animate().fadeIn(delay: 1100.ms, duration: 400.ms),
            ],

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  String _feelsLikeLabel(WeatherModel w) {
    final diff = w.feelsLike - w.temperature;
    if (diff > 3) return 'Warmer than actual';
    if (diff < -3) return 'Cooler than actual';
    return 'Similar to actual';
  }

  Widget _buildBottomNav() {
    final isDark = widget.isDarkMode;
    final theme = Theme.of(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: GlassDecoration.navBar(isDark: isDark),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home_rounded, 'Home', 0, theme),
                  _navItem(Icons.search_rounded, 'Search', 1, theme),
                  _navItem(Icons.auto_awesome, 'Insights', 2, theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, ThemeData theme) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: SkyCastColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(50),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive
                  ? SkyCastColors.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: SkyCastColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
