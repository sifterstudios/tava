import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tava/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tava/features/settings/presentation/bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (previous, current) =>
                previous.themeMode != current.themeMode,
            builder: (context, state) {
              return ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Theme'),
                trailing: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode),
                    ),
                  ],
                  selected: {state.themeMode},
                  onSelectionChanged: (modes) {
                    context
                        .read<SettingsBloc>()
                        .add(UpdateThemeMode(modes.first));
                  },
                ),
              );
            },
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (previous, current) =>
                previous.metronomeSound != current.metronomeSound,
            builder: (context, state) {
              return ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Metronome Sound'),
                trailing: DropdownButton<String>(
                  value: state.metronomeSound,
                  items: const [
                    DropdownMenuItem(
                      value: 'click',
                      child: Text('Click'),
                    ),
                    DropdownMenuItem(
                      value: 'wood',
                      child: Text('Wood'),
                    ),
                    DropdownMenuItem(
                      value: 'digital',
                      child: Text('Digital'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<SettingsBloc>()
                          .add(UpdateMetronomeSound(value));
                    }
                  },
                ),
              );
            },
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (previous, current) =>
                previous.trackWeather != current.trackWeather,
            builder: (context, state) {
              return SwitchListTile(
                secondary: const Icon(Icons.cloud),
                title: const Text('Track Weather'),
                subtitle: const Text(
                  'Record weather conditions during practice sessions',
                ),
                value: state.trackWeather,
                onChanged: (value) {
                  context
                      .read<SettingsBloc>()
                      .add(UpdateWeatherTracking(value));
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );
            },
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Version ${snapshot.data!.version} (${snapshot.data!.buildNumber})',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}