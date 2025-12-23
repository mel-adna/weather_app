import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TemperatureUnit { celsius, fahrenheit }

class SettingsNotifier extends Notifier<TemperatureUnit> {
  @override
  TemperatureUnit build() {
    return TemperatureUnit.celsius; // Default
  }

  void toggleUnit() {
    state = state == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, TemperatureUnit>(
  () {
    return SettingsNotifier();
  },
);
