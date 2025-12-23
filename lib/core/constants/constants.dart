import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';
}
