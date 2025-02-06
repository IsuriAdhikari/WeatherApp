import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  Future<WeatherModel?> fetchWeather(String cityName, String apiKey) async {
    // 5 days forecast
    final url =
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName&days=5';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      print('Failed to fetch weather: ${response.statusCode}');
      return null;
    }
  }
}
