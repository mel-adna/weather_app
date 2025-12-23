import 'package:equatable/equatable.dart';
import '../../domain/entities/weather.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather? weather;
  final List<Weather>? forecast;
  final String? errorMessage;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.weather,
    this.forecast,
    this.errorMessage,
  });

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    List<Weather>? forecast,
    String? errorMessage,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      forecast: forecast ?? this.forecast,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, weather, forecast, errorMessage];
}
