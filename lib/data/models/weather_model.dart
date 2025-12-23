import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.description,
    required super.mainCondition,
    required super.iconCode,
    required super.humidity,
    required super.windSpeed,
    required super.dateTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      mainCondition: json['weather'][0]['main'],
      iconCode: json['weather'][0]['icon'],
      humidity: (json['main']['humidity'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'main': {'temp': temperature, 'humidity': humidity},
      'weather': [
        {'description': description, 'main': mainCondition, 'icon': iconCode},
      ],
      'wind': {'speed': windSpeed},
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
    };
  }
}
