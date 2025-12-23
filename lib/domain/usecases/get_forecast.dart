import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetForecast implements UseCase<List<Weather>, GetForecastParams> {
  final WeatherRepository repository;

  GetForecast(this.repository);

  @override
  Future<Either<Failure, List<Weather>>> call(GetForecastParams params) async {
    return await repository.getForecast(params.cityName);
  }
}

class GetForecastParams extends Equatable {
  final String cityName;

  const GetForecastParams({required this.cityName});

  @override
  List<Object> get props => [cityName];
}
