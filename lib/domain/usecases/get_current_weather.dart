import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeather implements UseCase<Weather, GetCurrentWeatherParams> {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  @override
  Future<Either<Failure, Weather>> call(GetCurrentWeatherParams params) async {
    return await repository.getCurrentWeather(params.cityName);
  }
}

class GetCurrentWeatherParams extends Equatable {
  final String cityName;

  const GetCurrentWeatherParams({required this.cityName});

  @override
  List<Object> get props => [cityName];
}
