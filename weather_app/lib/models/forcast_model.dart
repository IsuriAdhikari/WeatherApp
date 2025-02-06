class Forecast {
  final String day;
  final String icon;
  final double temperature;

  Forecast({
    required this.day,
    required this.icon,
    required this.temperature,
  });

  // Factory method to create a Forecast instance from JSON
  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      day: json['date'],
      icon: json['day']['condition']['icon'],
      temperature: (json['day']['avgtemp_c'] as num).toDouble(),
    );
  }

  // Convert Forecast to JSON
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'icon': icon,
      'temperature': temperature,
    };
  }
}
