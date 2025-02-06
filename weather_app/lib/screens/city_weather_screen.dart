import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forcast_model.dart';

import '../widgets/forecast_slider.dart';

class CityWeatherScreen extends StatelessWidget {
  final WeatherModel weather;

  const CityWeatherScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    // Convert weather forecast data into Forecast objects
    List<Forecast> forecastList = weather.forecast.map((data) {
      return Forecast(
        day: data['day'],
        icon: data['icon'],
        temperature: data['temperature'],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(weather.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.network(
                    weather.getForecastWeatherIconUrl(
                        0), // For the first forecast day
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    weather.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    weather.condition,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${weather.temperature}°C',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const Divider(),
            Text(
              '3-Day Forecast',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ForecastSlider(
              forecast: forecastList,
              weather: weather,
            ), // Pass the Forecast list
          ],
        ),
      ),
    );
  }
}
