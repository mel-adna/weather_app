import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_location_weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_forecast.dart';
import 'weather_state.dart';

class WeatherNotifier extends StateNotifier<WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  final GetForecast getForecast;
  final GetCurrentLocationWeather getCurrentLocationWeather;

  WeatherNotifier({
    required this.getCurrentWeather,
    required this.getForecast,
    required this.getCurrentLocationWeather,
  }) : super(const WeatherState());

  Future<void> loadWeather(String cityName) async {
    state = state.copyWith(status: WeatherStatus.loading);

    final weatherResult = await getCurrentWeather(
      GetCurrentWeatherParams(cityName: cityName),
    );
    final forecastResult = await getForecast(
      GetForecastParams(cityName: cityName),
    );

    weatherResult.fold(
      (failure) => state = state.copyWith(
        status: WeatherStatus.error,
        errorMessage: failure.message,
      ),
      (weather) {
        forecastResult.fold(
          (failure) => state = state.copyWith(
            status: WeatherStatus.error,
            errorMessage: failure.message,
          ),
          (forecast) => state = state.copyWith(
            status: WeatherStatus.loaded,
            weather: weather,
            forecast: forecast,
          ),
        );
      },
    );
  }

  Future<void> loadCurrentLocationWeather() async {
    state = state.copyWith(status: WeatherStatus.loading);

    final result = await getCurrentLocationWeather(NoParams());

    result.fold(
      (failure) => state = state.copyWith(
        status: WeatherStatus.error,
        errorMessage: failure.message,
      ),
      (weather) {
        // After getting location weather, we should fetch forecast for that city
        loadWeather(weather.cityName);
      },
    );
  }
}
