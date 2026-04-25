class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final String description;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int sunrise;
  final int sunset;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int visibility;
  final int clouds;
  final String icon;
  final String mainCondition;
  final double windDeg;
  final int dt;
  final int timezone;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.visibility,
    required this.clouds,
    required this.icon,
    required this.mainCondition,
    required this.windDeg,
    required this.dt,
    required this.timezone,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      country: json['sys']?['country'] ?? '',
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      description: json['weather']?[0]?['description'] ?? '',
      humidity: json['main']?['humidity'] ?? 0,
      pressure: json['main']?['pressure'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      sunrise: json['sys']?['sunrise'] ?? 0,
      sunset: json['sys']?['sunset'] ?? 0,
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      tempMin: (json['main']?['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']?['temp_max'] ?? 0).toDouble(),
      visibility: json['visibility'] ?? 10000,
      clouds: json['clouds']?['all'] ?? 0,
      icon: json['weather']?[0]?['icon'] ?? '01d',
      mainCondition: json['weather']?[0]?['main'] ?? '',
      windDeg: (json['wind']?['deg'] ?? 0).toDouble(),
      dt: json['dt'] ?? 0,
      timezone: json['timezone'] ?? 0,
    );
  }


  String get weatherEmoji {
    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return _isNight ? '🌙' : '☀️';
      case 'clouds':
        return clouds > 70 ? '☁️' : '⛅';
      case 'rain':
      case 'drizzle':
        return '🌧️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
      case 'haze':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  bool get _isNight {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now < sunrise || now > sunset;
  }


  String get aiBriefing {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    String tempDesc;
    if (temperature > 35) {
      tempDesc = 'extremely hot';
    } else if (temperature > 30) {
      tempDesc = 'quite warm';
    } else if (temperature > 20) {
      tempDesc = 'pleasantly warm';
    } else if (temperature > 10) {
      tempDesc = 'cool';
    } else if (temperature > 0) {
      tempDesc = 'chilly';
    } else {
      tempDesc = 'freezing cold';
    }

    String humidityNote = '';
    if (humidity > 80) {
      humidityNote = ' with high humidity making it feel muggy';
    } else if (humidity > 60) {
      humidityNote = ' with moderate humidity';
    }

    String feelsLikeNote = '';
    if ((feelsLike - temperature).abs() > 3) {
      feelsLikeNote = ' It feels like ${feelsLike.round()}° outside.';
    }

    String windNote = '';
    if (windSpeed > 10) {
      windNote = ' Expect strong winds at ${windSpeed.round()} m/s.';
    } else if (windSpeed > 5) {
      windNote = ' There\'s a gentle breeze.';
    }

    String visNote = '';
    if (visibility < 2000) {
      visNote = ' ⚠️ Visibility is very low — drive carefully!';
    }

    return '$greeting! It\'s currently $tempDesc at ${temperature.round()}° in $cityName with ${description.toLowerCase()}$humidityNote.$feelsLikeNote$windNote$visNote';
  }


  List<Map<String, String>> get outfitSuggestions {
    List<Map<String, String>> items = [];

    // Temperature-based
    if (temperature > 30) {
      items.add({'icon': '👕', 'label': 'Light T-Shirt', 'reason': 'Stay cool'});
      items.add({'icon': '🩳', 'label': 'Shorts', 'reason': 'Hot weather'});
      items.add({'icon': '🧢', 'label': 'Cap / Hat', 'reason': 'Sun protection'});
    } else if (temperature > 20) {
      items.add({'icon': '👔', 'label': 'Light Shirt', 'reason': 'Comfortable'});
      items.add({'icon': '👖', 'label': 'Light Pants', 'reason': 'Mild weather'});
    } else if (temperature > 10) {
      items.add({'icon': '🧥', 'label': 'Light Jacket', 'reason': 'It\'s cool'});
      items.add({'icon': '👖', 'label': 'Jeans', 'reason': 'Stay warm'});
    } else {
      items.add({'icon': '🧥', 'label': 'Heavy Coat', 'reason': 'It\'s cold!'});
      items.add({'icon': '🧣', 'label': 'Scarf', 'reason': 'Bundle up'});
      items.add({'icon': '🧤', 'label': 'Gloves', 'reason': 'Freezing temps'});
    }

    // Weather condition-based
    if (mainCondition.toLowerCase().contains('rain') ||
        mainCondition.toLowerCase().contains('drizzle')) {
      items.add({'icon': '☂️', 'label': 'Umbrella', 'reason': 'Rain expected'});
      items.add({'icon': '🥾', 'label': 'Waterproof Shoes', 'reason': 'Wet ground'});
    }

    if (mainCondition.toLowerCase() == 'clear' && !_isNight) {
      items.add({'icon': '🕶️', 'label': 'Sunglasses', 'reason': 'Bright & sunny'});
      items.add({'icon': '🧴', 'label': 'Sunscreen', 'reason': 'UV protection'});
    }

    if (mainCondition.toLowerCase().contains('snow')) {
      items.add({'icon': '🥾', 'label': 'Snow Boots', 'reason': 'Snowy ground'});
    }

    return items;
  }


  List<Map<String, dynamic>> get activitySuggestions {
    List<Map<String, dynamic>> activities = [];

    if (mainCondition.toLowerCase() == 'clear' && temperature > 15 && temperature < 35) {
      activities.add({
        'icon': '🏃',
        'title': 'Morning Jog',
        'time': '6:00 - 8:00 AM',
        'type': 'best',
      });
      activities.add({
        'icon': '🌳',
        'title': 'Park Visit',
        'time': 'Anytime today',
        'type': 'best',
      });
    }

    if (temperature > 35) {
      activities.add({
        'icon': '🏖️',
        'title': 'Swimming',
        'time': 'Beat the heat',
        'type': 'best',
      });
      activities.add({
        'icon': '🚫',
        'title': 'Outdoor Sports',
        'time': '11 AM - 4 PM',
        'type': 'avoid',
      });
    }

    if (mainCondition.toLowerCase().contains('rain')) {
      activities.add({
        'icon': '📚',
        'title': 'Indoor Reading',
        'time': 'Cozy day in',
        'type': 'best',
      });
      activities.add({
        'icon': '🎬',
        'title': 'Movie Marathon',
        'time': 'Perfect weather',
        'type': 'best',
      });
      activities.add({
        'icon': '🚫',
        'title': 'Outdoor Dining',
        'time': 'Too wet',
        'type': 'avoid',
      });
    }

    if (mainCondition.toLowerCase().contains('snow')) {
      activities.add({
        'icon': '⛷️',
        'title': 'Skiing',
        'time': 'Great snow day!',
        'type': 'best',
      });
    }

    if (windSpeed > 8) {
      activities.add({
        'icon': '🪁',
        'title': 'Kite Flying',
        'time': 'Windy conditions',
        'type': 'best',
      });
    }

    if (activities.isEmpty) {
      activities.add({
        'icon': '☕',
        'title': 'Café Visit',
        'time': 'Enjoy the day',
        'type': 'best',
      });
      activities.add({
        'icon': '🚶',
        'title': 'Evening Walk',
        'time': 'After 5 PM',
        'type': 'best',
      });
    }

    return activities;
  }


  String get windDirection {
    if (windDeg >= 337.5 || windDeg < 22.5) return 'N';
    if (windDeg < 67.5) return 'NE';
    if (windDeg < 112.5) return 'E';
    if (windDeg < 157.5) return 'SE';
    if (windDeg < 202.5) return 'S';
    if (windDeg < 247.5) return 'SW';
    if (windDeg < 292.5) return 'W';
    return 'NW';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {
        'country': country,
        'sunrise': sunrise,
        'sunset': sunset,
      },
      'main': {
        'temp': temperature,
        'humidity': humidity,
        'pressure': pressure,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
      },
      'weather': [
        {'description': description, 'icon': icon, 'main': mainCondition}
      ],
      'wind': {
        'speed': windSpeed,
        'deg': windDeg,
      },
      'visibility': visibility,
      'clouds': {'all': clouds},
      'dt': dt,
      'timezone': timezone,
    };
  }
}
