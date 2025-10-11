class Weather {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final String main;
  final String location;
  final DateTime timestamp;

  Weather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.main,
    required this.location,
    required this.timestamp,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      description: json['description'] as String,
      icon: json['icon'] as String,
      main: json['main'] as String,
      location: json['location'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'description': description,
      'icon': icon,
      'main': main,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class WeatherForecast {
  final List<WeatherDay> days;

  WeatherForecast({required this.days});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['days'];
    List<WeatherDay> days = list
        .map((item) => WeatherDay.fromJson(item))
        .toList();
    return WeatherForecast(days: days);
  }
}

class WeatherDay {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String icon;
  final String main;

  WeatherDay({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.icon,
    required this.main,
  });

  factory WeatherDay.fromJson(Map<String, dynamic> json) {
    return WeatherDay(
      date: DateTime.parse(json['date'] as String),
      minTemp: (json['minTemp'] as num).toDouble(),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      description: json['description'] as String,
      icon: json['icon'] as String,
      main: json['main'] as String,
    );
  }
}
