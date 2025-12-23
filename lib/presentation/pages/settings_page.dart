import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../widgets/glass_container.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUnit = ref.watch(settingsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUnitSection(context, ref, currentUnit),
                const SizedBox(height: 20),
                _buildAboutSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitSection(
    BuildContext context,
    WidgetRef ref,
    TemperatureUnit currentUnit,
  ) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Units',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Temperature Unit',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Row(
                children: [
                  Text(
                    '°C',
                    style: TextStyle(
                      color: currentUnit == TemperatureUnit.celsius
                          ? Colors.white
                          : Colors.white30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: currentUnit == TemperatureUnit.fahrenheit,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).toggleUnit();
                    },
                    activeThumbColor: Colors.white,
                    activeTrackColor: Colors.orange,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.white24,
                  ),
                  Text(
                    '°F',
                    style: TextStyle(
                      color: currentUnit == TemperatureUnit.fahrenheit
                          ? Colors.white
                          : Colors.white30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoRow('App Version', '1.0.0'),
          const Divider(color: Colors.white24),
          _buildInfoRow('Developer', 'mel-adna'),
          const Divider(color: Colors.white24),
          _buildInfoRow('API', 'OpenWeatherMap'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
