import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/data/models/weather_model.dart';

void main() {
  // Adjusted for null safety and logic

  test('fromJson should return a valid model from JSON', () async {
    final Map<String, dynamic> jsonMap = json.decode(fixture('weather.json'));
    final result = WeatherModel.fromJson(jsonMap);

    expect(result.cityName, 'London');
    expect(result.temperature, 20.0);
    expect(result.humidity, 50.0);
  });
}

String fixture(String name) => """
{
  "name": "London",
  "main": {
    "temp": 20.0,
    "humidity": 50
  },
  "weather": [
    {
      "description": "clear sky",
      "main": "Clear",
      "icon": "01d"
    }
  ],
  "wind": {
    "speed": 3.5
  },
  "dt": 1625245873
}
""";
// Simplified fixture inline
