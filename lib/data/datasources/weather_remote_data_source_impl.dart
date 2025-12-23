import 'package:dio/dio.dart';
import '../../core/constants/constants.dart';
import '../../core/errors/failures.dart';
import '../models/weather_model.dart';
import 'weather_remote_data_source.dart';

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final response = await dio.get(
      '${Constants.baseUrl}/weather',
      queryParameters: {
        'q': cityName,
        'appid': Constants.apiKey,
        'units': 'metric',
      },
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw const ServerFailure('Failed to load weather data');
    }
  }

  @override
  Future<List<WeatherModel>> getForecast(String cityName) async {
    final response = await dio.get(
      '${Constants.baseUrl}/forecast',
      queryParameters: {
        'q': cityName,
        'appid': Constants.apiKey,
        'units': 'metric',
      },
    );

    if (response.statusCode == 200) {
      final List list = response.data['list'];
      return list.map((e) => WeatherModel.fromJson(e)).toList();
    } else {
      throw const ServerFailure('Failed to load forecast data');
    }
  }

  @override
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    final response = await dio.get(
      '${Constants.baseUrl}/weather',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': Constants.apiKey,
        'units': 'metric',
      },
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw const ServerFailure('Failed to load weather data');
    }
  }
}
