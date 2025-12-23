import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/weather_remote_data_source.dart';
import '../../data/datasources/weather_remote_data_source_impl.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/get_current_location_weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_forecast.dart';

// Core Providers
final dioProvider = Provider((ref) => Dio());

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>(
  (ref) => WeatherRemoteDataSourceImpl(dio: ref.read(dioProvider)),
);

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(
    remoteDataSource: ref.read(weatherRemoteDataSourceProvider),
  ),
);

// UseCases Providers
final getCurrentWeatherUseCaseProvider = Provider(
  (ref) => GetCurrentWeather(ref.read(weatherRepositoryProvider)),
);

final getForecastUseCaseProvider = Provider(
  (ref) => GetForecast(ref.read(weatherRepositoryProvider)),
);

final getCurrentLocationWeatherUseCaseProvider = Provider(
  (ref) => GetCurrentLocationWeather(ref.read(weatherRepositoryProvider)),
);
