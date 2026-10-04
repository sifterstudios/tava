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
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Appearance', style: theme.textTheme.titleMedium),
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (previous, current) =>
                previous.themeMode != current.themeMode,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode_rounded),
                            label: Text('Light'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.system,
                            icon: Icon(Icons.brightness_auto_rounded),
                            label: Text('System'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode_rounded),
                            label: Text('Dark'),
                          ),
                        ],
                        selected: {state.themeMode},
                        onSelectionChanged: (modes) {
                          context
                              .read<SettingsBloc>()
                              .add(UpdateThemeMode(modes.first));
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('Practice', style: theme.textTheme.titleMedium),
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (previous, current) =>
                previous.metronomeSound != current.metronomeSound,
            builder: (context, state) {
              return ListTile(
                leading: const Icon(Icons.music_note_rounded),
                title: const Text('Metronome sound'),
                subtitle: Text(state.metronomeSound),
                trailing: DropdownButton<String>(
                  value: state.metronomeSound,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: 'click', child: Text('Click')),
                    DropdownMenuItem(value: 'wood', child: Text('Wood')),
                    DropdownMenuItem(value: 'digital', child: Text('Digital')),
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
                secondary: const Icon(Icons.cloud_outlined),
                title: const Text('Track weather'),
                subtitle: const Text(
                  'Attach local weather to practice sessions when available',
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
          const Divider(height: 32),
          ListTile(
            leading: Icon(
              Icons.logout_rounded,
              color: theme.colorScheme.error,
            ),
            title: Text(
              'Sign out',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _confirmSignOut(context),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Version ${snapshot.data!.version} '
                  '(${snapshot.data!.buildNumber})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final authBloc = context.read<AuthBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Sign out of Tava on this device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      authBloc.add(LogoutRequested());
    }
  }
}
