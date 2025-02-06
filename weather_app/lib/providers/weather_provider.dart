import 'package:flutter/material.dart';
import 'package:weather_app/services/db_helper.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final List<WeatherModel> _cities = [];
  final WeatherService _weatherService = WeatherService();
  final String _apiKey = '87507141cb9843fb9ec135229250502';
  final DBHelper _dbHelper = DBHelper();

  List<WeatherModel> get cities => _cities;

  Future<void> fetchAndSetCities() async {
    final dbCities = await _dbHelper.getCities();
    _cities.clear();
    _cities.addAll(dbCities);
    notifyListeners();
  }

  Future<void> addCity(String cityName) async {
    if (_cities
        .any((city) => city.name.toLowerCase() == cityName.toLowerCase())) {
      throw Exception('City is already added');
    }

    try {
      final weather = await _weatherService.fetchWeather(cityName, _apiKey);
      if (weather != null) {
        _cities.add(weather);
        await _dbHelper.insertCity(weather);
        notifyListeners();
      } else {
        throw Exception('City not found');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeCity(int index) async {
    final cityName = _cities[index].name;
    _cities.removeAt(index);
    await _dbHelper.deleteCity(cityName);
    notifyListeners();
  }

  Future<void> clearCities() async {
    _cities.clear();
    await _dbHelper.deleteAllCities();
    notifyListeners();
  }
}
