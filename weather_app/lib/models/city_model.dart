class City {
  final String name;
  final String icon;
  final double temperature;
  final String day;

  City({
    required this.name,
    required this.icon,
    required this.temperature,
    required this.day,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String,
      icon: json['icon'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      day: json['day'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'temperature': temperature,
      'day': day,
    };
  }
}
