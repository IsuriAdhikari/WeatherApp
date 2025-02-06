import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/providers/weather_provider.dart';

class MockWeatherProvider extends WeatherProvider {
  final List<WeatherModel> _mockCities = [];

  @override
  List<WeatherModel> get cities => _mockCities;

  @override
  Future<void> addCity(String cityName) async {
    // Mock the behavior of adding a city
    if (_mockCities
        .any((city) => city.name.toLowerCase() == cityName.toLowerCase())) {
      throw Exception('City is already added (mock)');
    }

    // Simulate adding mock data
    final mockWeather = WeatherModel(
      name: cityName,
      condition: "Sunny",
      temperature: 25.0,
      forecast: [
        {"day": "Monday", "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "temperature": 22.0},
        {"day": "Tuesday", "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "temperature": 24.0},
        {"day": "Wednesday", "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "temperature": 26.0},
      ],
    );
    _mockCities.add(mockWeather);

    // Simulate a delay to mimic an asynchronous operation
    await Future.delayed(Duration(milliseconds: 500));
    notifyListeners();
  }

  @override
  Future<void> removeCity(int index) async {
    // Mock the behavior of removing a city
    if (index >= 0 && index < _mockCities.length) {
      _mockCities.removeAt(index);
      notifyListeners();
    } else {
      throw Exception('Index out of range (mock)');
    }
  }
}
