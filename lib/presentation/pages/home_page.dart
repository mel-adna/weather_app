import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../providers/weather_notifier.dart';
import '../providers/weather_state.dart';
import '../providers/settings_provider.dart';
import 'settings_page.dart';
import '../widgets/glass_container.dart';
import '../../domain/entities/weather.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load default city or current location on start
    // Future.microtask(() => ref.read(weatherNotifierProvider.notifier).loadCurrentLocationWeather());
    // For manual testing without GPS permissions setup in emulator, let's load a default city
    Future.microtask(
      () => ref.read(weatherNotifierProvider.notifier).loadWeather('Tetouan'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weatherNotifierProvider);
    final unit = ref.watch(settingsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Weather App', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () {
              ref
                  .read(weatherNotifierProvider.notifier)
                  .loadCurrentLocationWeather();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4facfe), // Light Blue
              Color(0xFF00f2fe), // Cyan
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchField(),
                const SizedBox(height: 20),
                Expanded(child: _buildBody(state, unit)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      borderRadius: BorderRadius.circular(30),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter city name',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                ref
                    .read(weatherNotifierProvider.notifier)
                    .loadWeather(_searchController.text);
              }
            },
          ),
          border: InputBorder.none,
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            ref.read(weatherNotifierProvider.notifier).loadWeather(value);
          }
        },
      ),
    );
  }

  Widget _buildBody(WeatherState state, TemperatureUnit unit) {
    if (state.status == WeatherStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    } else if (state.status == WeatherStatus.error) {
      return Center(
        child: GlassContainer(
          child: Text(
            'Error: ${state.errorMessage}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } else if (state.status == WeatherStatus.loaded && state.weather != null) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.blueAccent,
        onRefresh: () async {
          if (state.weather != null) {
            ref
                .read(weatherNotifierProvider.notifier)
                .loadWeather(state.weather!.cityName);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildCurrentWeather(state.weather!, unit),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '7-Day Forecast',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 5, color: Colors.black26)],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildForecastList(state.forecast, unit),
            ],
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Search for a city',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
  }

  double _convertTemp(double celsius, TemperatureUnit unit) {
    if (unit == TemperatureUnit.fahrenheit) {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  Widget _buildCurrentWeather(Weather weather, TemperatureUnit unit) {
    final temp = _convertTemp(weather.temperature, unit);
    final unitString = unit == TemperatureUnit.celsius ? 'C' : 'F';

    return GlassContainer(
      opacity: 0.15,
      child: Column(
        children: [
          Text(
            weather.cityName,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            DateFormat('EEEE, d MMMM').format(DateTime.now()),
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Image.network(
            'https://openweathermap.org/img/wn/${weather.iconCode}@4x.png',
            width: 120,
            height: 120,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.wb_sunny_rounded,
                size: 100,
                color: Colors.yellowAccent,
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            '${temp.toStringAsFixed(1)}°$unitString',
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              letterSpacing: 2,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherInfoItem(
                Icons.water_drop_outlined,
                '${weather.humidity}%',
                'Humidity',
              ),
              Container(width: 1, height: 40, color: Colors.white30),
              _buildWeatherInfoItem(
                Icons.air_outlined,
                '${weather.windSpeed} km/h',
                'Wind',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildForecastList(List<Weather>? forecast, TemperatureUnit unit) {
    if (forecast == null || forecast.isEmpty) {
      return const Text(
        'No forecast data',
        style: TextStyle(color: Colors.white),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: forecast.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = forecast[index];
        final temp = _convertTemp(item.temperature, unit);

        return GlassContainer(
          opacity: 0.1,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('E HH:mm').format(item.dateTime),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://openweathermap.org/img/wn/${item.iconCode}.png',
                      width: 30,
                      height: 30,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.cloud_queue,
                          color: Colors.white70,
                          size: 20,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        item.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${temp.toStringAsFixed(1)}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
