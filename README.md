# TAVA

A comprehensive practice journal for musicians built with Flutter, featuring:

- **Cross-platform UI** using flutter_platform_widgets for seamless Material/Cupertino design adaptation
- **Practice Session Tracking** with timer, exercise logging, and progress analytics
- **Customizable Metronome** with presets and BPM history
- **Exercise Library** with categorization and favorites
- **Progress Analytics** with charts and statistics
- **Weather Integration** for practice environment tracking
- **Mood & Wellness Metrics** for holistic practice insights

## Architecture

This app follows Clean Architecture principles with:

- **Domain Layer**: Business logic and entities
- **Data Layer**: Repositories and data sources
- **Presentation Layer**: BLoC state management with platform-adaptive UI

## Key Features

### Cross-Platform Design
- Seamless adaptation between Material Design (Android) and Cupertino (iOS)
- Platform-specific navigation patterns and interactions
- Consistent functionality across all platforms

### Practice Management
- Start/pause/resume practice sessions
- Add exercises with BPM and duration tracking
- Rate exercises and add notes
- Weather data integration for environmental context

### Progress Tracking
- Daily and weekly practice time charts
- Category-based practice breakdown
- BPM progression tracking
- Exercise popularity analytics

### Metronome
- Customizable BPM with visual and audio feedback
- Save and load presets
- Time signature support
- BPM history tracking

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Setup
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate dependency injection code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Configure Supabase environment variables in your deployment environment
5. Run the app:
   ```bash
   flutter run
   ```

## Environment Variables

Set these environment variables for Supabase integration:
- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_ANON_KEY`: Your Supabase anonymous key

## Dependencies

### Core
- `flutter_bloc`: State management
- `get_it` & `injectable`: Dependency injection
- `flutter_platform_widgets`: Cross-platform UI components

### UI & Design
- `flex_color_scheme`: Advanced theming
- `google_fonts`: Typography
- `fl_chart`: Data visualization
- `lottie`: Animations

### Backend & Storage
- `supabase_flutter`: Backend as a service
- `hive`: Local storage
- `shared_preferences`: Settings storage

### Audio & Sensors
- `just_audio`: Metronome audio
- `weather`: Weather API integration
- `geolocator`: Location services

## Project Structure

```
lib/
├── app/                    # App configuration and routing
├── core/                   # Core utilities and DI
├── features/              # Feature modules
│   ├── auth/              # Authentication
│   ├── dashboard/         # Main dashboard
│   ├── exercise_library/  # Exercise management
│   ├── metronome/         # Metronome functionality
│   ├── practice_session/  # Practice tracking
│   ├── progress/          # Analytics and charts
│   └── settings/          # App settings
└── main.dart              # App entry point
```

Each feature follows Clean Architecture:
```
feature/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

## Contributing

1. Follow the existing architecture patterns
2. Use BLoC for state management
3. Implement platform-adaptive UI with flutter_platform_widgets
4. Write tests for business logic
5. Follow Dart/Flutter style guidelines

## License

This project is licensed under the MIT License.