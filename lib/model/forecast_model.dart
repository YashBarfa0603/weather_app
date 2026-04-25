class ForecastItem {
  final int dt;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;
  final String mainCondition;
  final int humidity;
  final double windSpeed;
  final int clouds;
  final double pop; 

  ForecastItem({
    required this.dt,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.humidity,
    required this.windSpeed,
    required this.clouds,
    required this.pop,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dt: json['dt'] ?? 0,
      temp: (json['main']?['temp'] ?? 0).toDouble(),
      tempMin: (json['main']?['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']?['temp_max'] ?? 0).toDouble(),
      description: json['weather']?[0]?['description'] ?? '',
      icon: json['weather']?[0]?['icon'] ?? '01d',
      mainCondition: json['weather']?[0]?['main'] ?? '',
      humidity: json['main']?['humidity'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      clouds: json['clouds']?['all'] ?? 0,
      pop: (json['pop'] ?? 0).toDouble(),
    );
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(dt * 1000);

  String get weatherEmoji {
    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return icon.contains('n') ? '🌙' : '☀️';
      case 'clouds':
        return clouds > 70 ? '☁️' : '⛅';
      case 'rain':
      case 'drizzle':
        return '🌧️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      default:
        return '🌤️';
    }
  }
}

class ForecastModel {
  final List<ForecastItem> items;
  final String cityName;

  ForecastModel({
    required this.items,
    required this.cityName,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List? ?? [];
    return ForecastModel(
      items: list.map((e) => ForecastItem.fromJson(e)).toList(),
      cityName: json['city']?['name'] ?? '',
    );
  }


  List<ForecastItem> get hourly => items.take(12).toList();


  List<ForecastItem> get daily {
    Map<String, ForecastItem> dailyMap = {};
    for (var item in items) {
      final dateKey = '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';
      final hour = item.dateTime.hour;

      if (!dailyMap.containsKey(dateKey) || (hour >= 11 && hour <= 14)) {
        dailyMap[dateKey] = item;
      }
    }
    return dailyMap.values.toList();
  }

  
  List<double> get rainProbabilities => items.take(8).map((e) => e.pop * 100).toList();
}
