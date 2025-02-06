import 'package:flutter/material.dart';
import 'package:weather_app/models/forcast_model.dart';
import 'package:weather_app/models/weather_model.dart';

class ForecastSlider extends StatelessWidget {
  final List<Forecast> forecast;
  final WeatherModel weather;

  const ForecastSlider(
      {super.key, required this.forecast, required this.weather});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.length,
        itemBuilder: (context, index) {
          final Forecast dayForecast = forecast[index];

          return Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      weather.getForecastWeatherIconUrl(
                          0), // For the first forecast day
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      weather.condition,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      dayForecast.day,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text('${dayForecast.temperature}°C'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
