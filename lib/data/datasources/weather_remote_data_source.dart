import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String cityName);
  Future<List<WeatherModel>> getForecast(String cityName);
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon);
}
