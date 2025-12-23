import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperature;
  final String description;
  final String mainCondition;
  final String iconCode;
  final double humidity;
  final double windSpeed;
  final DateTime dateTime;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.mainCondition,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
    cityName,
    temperature,
    description,
    mainCondition,
    iconCode,
    humidity,
    windSpeed,
    dateTime,
  ];
}
