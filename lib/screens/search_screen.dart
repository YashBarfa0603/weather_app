import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/sevices/weather_servic.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/theme.dart';
import 'package:weather_app/widgets/glass_card.dart';

class SearchScreen extends StatefulWidget {
  final Function(String) onCitySelected;
  const SearchScreen({super.key, required this.onCitySelected});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  final _weatherSvc = WeatherServices();
  final _recent = ['Mumbai', 'London', 'Tokyo', 'New York', 'Dubai'];
  final _saved = ['Mumbai', 'Delhi', 'Bangalore', 'London', 'Tokyo'];
  bool _searching = false;
  WeatherModel? _result;
  String? _error;
  WeatherModel? _cmp1;
  WeatherModel? _cmp2;
  bool _cmpLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCompare('Delhi', 'Indore');
  }

  void _search(String city) async {
    if (city.trim().isEmpty) return;
    setState(() {
      _searching = true;
      _error = null;
      _result = null;
    });
    try {
      final w = await _weatherSvc.fetchWeather(city.trim());
      setState(() {
        _result = w;
        _searching = false;
        if (!_recent.contains(w.cityName)) {
          _recent.insert(0, w.cityName);
          if (_recent.length > 8) _recent.removeLast();
        }
      });
    } catch (e) {
      setState(() {
        _searching = false;
        _error = 'City not found';
      });
    }
  }

  void _loadCompare(String a, String b) async {
    setState(() => _cmpLoading = true);
    try {
      final r = await Future.wait([
        _weatherSvc.fetchWeather(a),
        _weatherSvc.fetchWeather(b),
      ]);
      setState(() {
        _cmp1 = r[0];
        _cmp2 = r[1];
        _cmpLoading = false;
      });
    } catch (_) {
      setState(() => _cmpLoading = false);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: WeatherGradients.getGradient('', isDark),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Text(
                  'Search',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: GlassDecoration.pill(isDark: isDark),
                      child: TextField(
                        controller: _searchCtrl,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Search any city...',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() {
                                      _result = null;
                                      _error = null;
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        onSubmitted: _search,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                ),
              ),
              if (_searching)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: SkyCastColors.primary,
                    ),
                  ),
                ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: GlassCard(
                    child: Row(
                      children: [
                        const Text('😕', style: TextStyle(fontSize: 30)),
                        const SizedBox(width: 12),
                        Text(_error!, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              if (_result != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: GlassCard(
                    onTap: () => widget.onCitySelected(_result!.cityName),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_result!.cityName}, ${_result!.country}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _result!.description,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _result!.weatherEmoji,
                              style: const TextStyle(fontSize: 36),
                            ),
                            Text(
                              '${_result!.temperature.round()}°',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
              // Recent
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Text(
                  'RECENT SEARCHES',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 0.8,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _recent.length,
                  itemBuilder: (c, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => widget.onCitySelected(_recent[i]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: GlassDecoration.pill(isDark: isDark),
                            child: Text(
                              _recent[i],
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Compare
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Row(
                  children: [
                    const Text('⚔️', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      'COMPARE WEATHER',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.8,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (_cmpLoading)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: SkyCastColors.primary,
                    ),
                  ),
                )
              else if (_cmp1 != null && _cmp2 != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(child: _cmpCard(_cmp1!, theme)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'VS',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: SkyCastColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Expanded(child: _cmpCard(_cmp2!, theme)),
                    ],
                  ),
                ),
              // Saved
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.bookmark_outline,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'SAVED LOCATIONS',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.8,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: _saved
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GlassCard(
                            onTap: () => widget.onCitySelected(c),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_city, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    c,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cmpCard(WeatherModel w, ThemeData t) => GlassCard(
    padding: const EdgeInsets.all(14),
    child: Column(
      children: [
        Text(w.weatherEmoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 6),
        Text(
          w.cityName,
          style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${w.temperature.round()}°',
          style: t.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        _cmpRow('💧', '${w.humidity}%', t),
        _cmpRow('💨', '${w.windSpeed.round()} m/s', t),
        _cmpRow('👁', '${(w.visibility / 1000).round()} km', t),
      ],
    ),
  );

  Widget _cmpRow(String e, String v, ThemeData t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Text(e, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            v,
            style: t.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
