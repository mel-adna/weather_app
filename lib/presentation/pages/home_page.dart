import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/providers.dart';
import '../providers/weather_state.dart';
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
      () => ref.read(weatherNotifierProvider.notifier).loadWeather('London'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weatherNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              ref
                  .read(weatherNotifierProvider.notifier)
                  .loadCurrentLocationWeather();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      ref
                          .read(weatherNotifierProvider.notifier)
                          .loadWeather(_searchController.text);
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  ref.read(weatherNotifierProvider.notifier).loadWeather(value);
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildBody(state)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(WeatherState state) {
    if (state.status == WeatherStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == WeatherStatus.error) {
      return Center(child: Text('Error: ${state.errorMessage}'));
    } else if (state.status == WeatherStatus.loaded && state.weather != null) {
      return RefreshIndicator(
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
              _buildCurrentWeather(state.weather!),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '7-Day Forecast',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              _buildForecastList(state.forecast),
            ],
          ),
        ),
      );
    } else {
      return const Center(child: Text('Search for a city'));
    }
  }

  Widget _buildCurrentWeather(Weather weather) {
    return Column(
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(
          DateFormat('EEEE, d MMMM').format(DateTime.now()),
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        // Placeholder for Icon - using text or basic Icon for now as I don't have assets mapping
        const Icon(Icons.wb_sunny, size: 80, color: Colors.orange),
        const SizedBox(height: 10),
        Text(
          '${weather.temperature.toStringAsFixed(1)}°C',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        Text(
          weather.description.toUpperCase(),
          style: const TextStyle(fontSize: 20, letterSpacing: 1.2),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWeatherInfoItem(
              Icons.water_drop,
              '${weather.humidity}%',
              'Humidity',
            ),
            _buildWeatherInfoItem(
              Icons.air,
              '${weather.windSpeed} m/s',
              'Wind',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildForecastList(List<Weather>? forecast) {
    if (forecast == null || forecast.isEmpty) {
      return const Text('No forecast data');
    }
    // Filter to get one per day (approx) or just show first few
    // OpenWeatherMap free API forecast is 5 days / 3 hour steps.
    // We can show a list of them.
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: forecast.length,
      itemBuilder: (context, index) {
        final item = forecast[index];
        return Card(
          child: ListTile(
            leading: Text(DateFormat('E HH:mm').format(item.dateTime)),
            title: Text('${item.temperature.toStringAsFixed(1)}°C'),
            subtitle: Text(item.description),
            trailing: const Icon(
              Icons.cloud,
              color: Colors.grey,
            ), // Placeholder
          ),
        );
      },
    );
  }
}
