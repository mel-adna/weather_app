# Flutter Weather App

A modern, beautiful, and robust weather application built with **Flutter**, utilizing **Clean Architecture** and **Riverpod** for state management. This app features a stunning **Glassmorphism** design, dynamic gradients, and real-time weather data from the OpenWeatherMap API.

![App Banner](https://via.placeholder.com/1200x600/4facfe/ffffff?text=Weather+App+Banner)

## Features

- **Current Weather**: Real-time temperature, humidity, wind speed, and weather conditions.
- **7-Day Forecast**: Scrollable list of future weather predictions with dynamic icons.
- **Dynamic Theming**: Background gradients that adapt to the weather/time (foundation laid).
- **Glassmorphism UI**: Modern frosted glass effect for cards and containers.
- **Dynamic Icons**: High-quality weather icons fetched directly from OpenWeatherMap.
- **Unit Conversion**: Toggle between **Celsius (C)** and **Fahrenheit (F)** in Settings.
- **Geolocation**: Automatically detects user location to show local weather.
- **City Search**: Search for weather conditions in any city worldwide.

## Tech Stack & Architecture

This project strictly follows **Clean Architecture** principles to ensure scalability, testability, and maintainability.

- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- **Network**: [dio](https://pub.dev/packages/dio)
- **Functional Programming**: [dartz](https://pub.dev/packages/dartz) (Either type for error handling)
- **Data Classes**: [freezed](https://pub.dev/packages/freezed) & [json_serializable](https://pub.dev/packages/json_serializable)
- **Location**: [geolocator](https://pub.dev/packages/geolocator)
- **Animations**: [flutter_animate](https://pub.dev/packages/flutter_animate)
- **Icons**: [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

### Architecture Layers

1.  **Domain Layer (Inner Circle)**:
    *   **Entities**: Core business objects (e.g., `Weather`).
    *   **Repositories (Interfaces)**: Contracts for data retrieval.
    *   **Use Cases**: Application-specific business rules.

2.  **Data Layer**:
    *   **Models**: DTOs (Data Transfer Objects) with JSON parsing logic.
    *   **Data Sources**: Remote (API) and local data fetching implementations.
    *   **Repositories (Implementation)**: Implementation of domain interfaces.

3.  **Presentation Layer**:
    *   **Providers**: Riverpod notifiers (`WeatherNotifier`, `SettingsNotifier`).
    *   **Pages**: UI screens (`HomePage`, `SettingsPage`).
    *   **Widgets**: Reusable UI components (`GlassContainer`).

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
- An API Key from [OpenWeatherMap](https://openweathermap.org/api).

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/mel-adna/weather_app.git
    cd weather_app
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Configure API Key**:
    Open `lib/core/constants/constants.dart` and replace the placeholder with your key:
    ```dart
    class Constants {
      static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
      static const String apiKey = 'YOUR_API_KEY_HERE'; // <--- Paste key here
    }
    ```

4.  **Run the app**:
    ```bash
    flutter run
    ```

## Screenshots

| Home Screen | Forecast | Settings |
|:---:|:---:|:---:|
| ![Home](<img width="387" height="842" alt="Screenshot 2025-12-23 220718" src="https://github.com/user-attachments/assets/1bc9b68c-9ff9-438e-b47e-7a924af567a6" />
) | ![Forecast](<img width="390" height="846" alt="Screenshot 2025-12-23 220807" src="https://github.com/user-attachments/assets/ab5b289f-46d2-4d9a-8111-224080c7c693" />
) | ![Settings](<img width="389" height="845" alt="Screenshot 2025-12-23 220736" src="https://github.com/user-attachments/assets/bb3bbd17-c93a-4682-9211-8559ed507b15" />
) |

## Testing

Run the included unit and widget tests:

```bash
flutter test
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
