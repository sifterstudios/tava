import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tava/features/settings/presentation/bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsBloc>()..add(LoadSettings()),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state.status == SettingsStatus.loading) {
            return Center(
              child: PlatformCircularProgressIndicator(),
            );
          }

          return ListView(
            children: [
              // Appearance Section
              _SectionHeader(title: 'Appearance'),
              PlatformWidget(
                material: (_, __) => ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text('Theme'),
                  subtitle: Text(_getThemeModeText(state.themeMode)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeDialog(context),
                ),
                cupertino: (_, __) => CupertinoListTile(
                  leading: const Icon(CupertinoIcons.paintbrush),
                  title: const Text('Theme'),
                  subtitle: Text(_getThemeModeText(state.themeMode)),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _showThemeDialog(context),
                ),
              ),

              // Audio Section
              _SectionHeader(title: 'Audio'),
              PlatformWidget(
                material: (_, __) => ListTile(
                  leading: const Icon(Icons.volume_up),
                  title: const Text('Metronome Sound'),
                  subtitle: Text(state.metronomeSound),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showMetronomeSoundDialog(context),
                ),
                cupertino: (_, __) => CupertinoListTile(
                  leading: const Icon(CupertinoIcons.speaker_2),
                  title: const Text('Metronome Sound'),
                  subtitle: Text(state.metronomeSound),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _showMetronomeSoundDialog(context),
                ),
              ),

              // Data Section
              _SectionHeader(title: 'Data & Privacy'),
              PlatformWidget(
                material: (_, __) => SwitchListTile(
                  secondary: const Icon(Icons.cloud),
                  title: const Text('Track Weather'),
                  subtitle: const Text('Include weather data in practice sessions'),
                  value: state.trackWeather,
                  onChanged: (value) => context
                      .read<SettingsBloc>()
                      .add(UpdateWeatherTracking(value)),
                ),
                cupertino: (_, __) => CupertinoListTile(
                  leading: const Icon(CupertinoIcons.cloud),
                  title: const Text('Track Weather'),
                  subtitle: const Text('Include weather data in practice sessions'),
                  trailing: CupertinoSwitch(
                    value: state.trackWeather,
                    onChanged: (value) => context
                        .read<SettingsBloc>()
                        .add(UpdateWeatherTracking(value)),
                  ),
                ),
              ),

              // Account Section
              _SectionHeader(title: 'Account'),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthAuthenticated) {
                    return Column(
                      children: [
                        PlatformWidget(
                          material: (_, __) => ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Profile'),
                            subtitle: Text(authState.user.email),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // Navigate to profile
                            },
                          ),
                          cupertino: (_, __) => CupertinoListTile(
                            leading: const Icon(CupertinoIcons.person),
                            title: const Text('Profile'),
                            subtitle: Text(authState.user.email),
                            trailing: const CupertinoListTileChevron(),
                            onTap: () {
                              // Navigate to profile
                            },
                          ),
                        ),
                        PlatformWidget(
                          material: (_, __) => ListTile(
                            leading: const Icon(Icons.logout, color: Colors.red),
                            title: const Text(
                              'Sign Out',
                              style: TextStyle(color: Colors.red),
                            ),
                            onTap: () => _showSignOutDialog(context),
                          ),
                          cupertino: (_, __) => CupertinoListTile(
                            leading: const Icon(
                              CupertinoIcons.square_arrow_right,
                              color: CupertinoColors.systemRed,
                            ),
                            title: const Text(
                              'Sign Out',
                              style: TextStyle(color: CupertinoColors.systemRed),
                            ),
                            onTap: () => _showSignOutDialog(context),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // About Section
              _SectionHeader(title: 'About'),
              PlatformWidget(
                material: (_, __) => ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  subtitle: const Text('Version 1.0.0'),
                  onTap: () => _showAboutDialog(context),
                ),
                cupertino: (_, __) => CupertinoListTile(
                  leading: const Icon(CupertinoIcons.info),
                  title: const Text('About'),
                  subtitle: const Text('Version 1.0.0'),
                  onTap: () => _showAboutDialog(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getThemeModeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context) {
    final options = [
      ('Light', ThemeMode.light),
      ('Dark', ThemeMode.dark),
      ('System', ThemeMode.system),
    ];

    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return PlatformWidget(
              material: (_, __) => RadioListTile<ThemeMode>(
                title: Text(option.$1),
                value: option.$2,
                groupValue: context.read<SettingsBloc>().state.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(UpdateThemeMode(value));
                    Navigator.of(context).pop();
                  }
                },
              ),
              cupertino: (_, __) => CupertinoListTile(
                title: Text(option.$1),
                trailing: context.read<SettingsBloc>().state.themeMode == option.$2
                    ? const Icon(CupertinoIcons.check_mark)
                    : null,
                onTap: () {
                  context.read<SettingsBloc>().add(UpdateThemeMode(option.$2));
                  Navigator.of(context).pop();
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          PlatformDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showMetronomeSoundDialog(BuildContext context) {
    final sounds = ['click', 'beep', 'wood', 'digital'];

    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text('Metronome Sound'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: sounds.map((sound) {
            return PlatformWidget(
              material: (_, __) => RadioListTile<String>(
                title: Text(sound.toUpperCase()),
                value: sound,
                groupValue: context.read<SettingsBloc>().state.metronomeSound,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(UpdateMetronomeSound(value));
                    Navigator.of(context).pop();
                  }
                },
              ),
              cupertino: (_, __) => CupertinoListTile(
                title: Text(sound.toUpperCase()),
                trailing: context.read<SettingsBloc>().state.metronomeSound == sound
                    ? const Icon(CupertinoIcons.check_mark)
                    : null,
                onTap: () {
                  context.read<SettingsBloc>().add(UpdateMetronomeSound(sound));
                  Navigator.of(context).pop();
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          PlatformDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          PlatformDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          PlatformDialogAction(
            child: PlatformText(
              'Sign Out',
              style: platformThemeData(
                context,
                material: (data) => const TextStyle(color: Colors.red),
                cupertino: (data) => const TextStyle(color: CupertinoColors.systemRed),
              ),
            ),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text('TAVA'),
        content: const Text(
          'A comprehensive practice journal for musicians with customizable metronome and progress tracking.\n\nVersion 1.0.0\nBuilt with Flutter',
        ),
        actions: [
          PlatformDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: PlatformText(
        title.toUpperCase(),
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.labelSmall?.copyWith(
            color: data.colorScheme.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
          cupertino: (data) => data.textTheme.textStyle.copyWith(
            color: CupertinoColors.secondaryLabel,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}