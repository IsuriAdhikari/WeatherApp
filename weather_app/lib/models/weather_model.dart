class WeatherModel {
  final String name;
  final String condition;
  final double temperature;
  final List<Map<String, dynamic>> forecast;

  WeatherModel({
    required this.name,
    required this.condition,
    required this.temperature,
    required this.forecast,
  });

  // Method to get the icon URL from OpenWeatherMap
  String getWeatherIconUrl(String iconCode) {
    return "https:$iconCode";
  }

  // Method to convert the JSON data into a WeatherModel instance
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    var forecastList = json['forecast']['forecastday'] as List;

    List<Map<String, dynamic>> forecastData = forecastList.map((item) {
      return {
        'day': item['date'],
        'icon': item['day']['condition']['icon'],
        'temperature': item['day']['avgtemp_c'],
      };
    }).toList();

    return WeatherModel(
      name: json['location']['name'],
      condition: json['current']['condition']['text'],
      temperature: json['current']['temp_c'],
      forecast: forecastData,
    );
  }

  // Method to get the icon URL for the forecasted weather
  String getForecastWeatherIconUrl(int index) {
    if (index < forecast.length) {
      String iconCode = forecast[index]['icon'];

      return getWeatherIconUrl(iconCode);
    }
    return ''; // Return empty if no icon is found
  }
}
