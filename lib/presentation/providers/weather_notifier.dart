import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_forecast.dart';
import 'providers.dart';
import 'weather_state.dart';

class WeatherNotifier extends Notifier<WeatherState> {
  @override
  WeatherState build() {
    return const WeatherState();
  }

  Future<void> loadWeather(String cityName) async {
    state = state.copyWith(status: WeatherStatus.loading);

    final getCurrentWeather = ref.read(getCurrentWeatherUseCaseProvider);
    final getForecast = ref.read(getForecastUseCaseProvider);

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

    final getCurrentLocationWeather = ref.read(
      getCurrentLocationWeatherUseCaseProvider,
    );
    final result = await getCurrentLocationWeather(NoParams());

    result.fold(
      (failure) => state = state.copyWith(
        status: WeatherStatus.error,
        errorMessage: failure.message,
      ),
      (weather) {
        loadWeather(weather.cityName);
      },
    );
  }
}

final weatherNotifierProvider = NotifierProvider<WeatherNotifier, WeatherState>(
  () {
    return WeatherNotifier();
  },
);
