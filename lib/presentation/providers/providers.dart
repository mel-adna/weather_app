import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/usecases/usecase.dart';
import '../../data/datasources/weather_remote_data_source.dart';
import '../../data/datasources/weather_remote_data_source_impl.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/get_current_location_weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_forecast.dart';
import 'weather_notifier.dart';
import 'weather_state.dart';

final dioProvider = Provider((ref) => Dio());

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>(
  (ref) => WeatherRemoteDataSourceImpl(dio: ref.read(dioProvider)),
);

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(
    remoteDataSource: ref.read(weatherRemoteDataSourceProvider),
  ),
);

final getCurrentWeatherUseCaseProvider = Provider(
  (ref) => GetCurrentWeather(ref.read(weatherRepositoryProvider)),
);

final getForecastUseCaseProvider = Provider(
  (ref) => GetForecast(ref.read(weatherRepositoryProvider)),
);

final getCurrentLocationWeatherUseCaseProvider = Provider(
  (ref) => GetCurrentLocationWeather(ref.read(weatherRepositoryProvider)),
);

final weatherNotifierProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
      return WeatherNotifier(
        getCurrentWeather: ref.read(getCurrentWeatherUseCaseProvider),
        getForecast: ref.read(getForecastUseCaseProvider),
        getCurrentLocationWeather: ref.read(
          getCurrentLocationWeatherUseCaseProvider,
        ),
      );
    });
