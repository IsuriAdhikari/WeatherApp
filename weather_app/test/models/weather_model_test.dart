import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather_model.dart';


void main() {
  test('should parse JSON and return valid WeatherModel', () {
    final json = {
      "location": {"name": "New York"},
      "current": {
        "condition": {"text": "Clear", "icon": "01d"},
        "temp_c": 15.0
      },
      "forecast": {
        "forecastday": [
          {
            "date": "2025-02-01",
            "day": {
              "condition": {"icon": "01d"},
              "avgtemp_c": 18.0,
            }
          }
        ]
      }
    };

    final weatherModel = WeatherModel.fromJson(json);

    expect(weatherModel.name, 'New York');
    expect(weatherModel.condition, 'Clear');
    expect(weatherModel.temperature, 15.0);
    expect(weatherModel.forecast[0]['day'], '2025-02-01');
    expect(weatherModel.forecast[0]['icon'], '01d');
  });

  test('should return correct weather icon URL', () {
    final weatherModel = WeatherModel(
      name: 'New York',
      condition: 'Clear',
      temperature: 15.0,
      forecast: [],
    );

    final iconUrl = weatherModel.getWeatherIconUrl('//cdn.weatherapi.com/weather/64x64/day/176.png');
    expect(iconUrl, 'https://cdn.weatherapi.com/weather/64x64/day/176.png');
    
  });
}
