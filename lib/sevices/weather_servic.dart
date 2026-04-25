import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/model/forecast_model.dart';

class WeatherServices {
  final String apiKey = process.env.API_KEY;
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

 
  Future<WeatherModel> fetchWeather(String cityName) async {
    final url = Uri.parse('$_baseUrl/weather?q=$cityName&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return WeatherModel.fromJson(jsonResponse);
    } else {
      throw Exception('City not found');
    }
  }

  
  Future<WeatherModel> fetchWeatherByCoords(double lat, double lon) async {
    final url = Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return WeatherModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to fetch weather for location');
    }
  }

 
  Future<ForecastModel> fetchForecast(String cityName) async {
    final url = Uri.parse('$_baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ForecastModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to fetch forecast');
    }
  }


  Future<ForecastModel> fetchForecastByCoords(double lat, double lon) async {
    final url = Uri.parse('$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ForecastModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to fetch forecast');
    }
  }
}