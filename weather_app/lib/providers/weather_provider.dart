import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_app/services/db_helper.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final List<WeatherModel> _cities = [];
  final WeatherService _weatherService = WeatherService();
  final DBHelper _dbHelper = DBHelper();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  List<WeatherModel> get cities => _cities;

  Future<void> saveApiKey(String apiKey) async {
    await _secureStorage.write(key: 'apiKey', value: apiKey);
  }

  Future<String?> getApiKey() async {
    return await _secureStorage.read(key: 'apiKey');
  }

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
      final apiKey = await getApiKey();
      if (apiKey == null) {
        throw Exception('API key is not set');
      }

      final weather = await _weatherService.fetchWeather(cityName, apiKey);
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
