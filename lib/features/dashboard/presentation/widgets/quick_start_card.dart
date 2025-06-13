import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

/// A card widget that provides a quick start option for practice sessions.
class QuickStartCard extends StatelessWidget {
  /// Creates a [QuickStartCard].
  const QuickStartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00FFFF).withValues(alpha: 0.1),
            const Color(0xFF00BFA5).withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00FFFF).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PlatformWidget(
                material: (_, __) => const Icon(
                  Icons.play_circle_filled,
                  color: Color(0xFF00FFFF),
                  size: 32,
                ),
                cupertino: (_, __) => const Icon(
                  CupertinoIcons.play_circle_fill,
                  color: Color(0xFF00FFFF),
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlatformText(
                      'Quick Start',
                      style: platformThemeData(
                        context,
                        material: (data) => data.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        cupertino: (data) =>
                            data.textTheme.navTitleTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    PlatformText(
                      'Begin your practice session',
                      style: platformThemeData(
                        context,
                        material: (data) => data.textTheme.bodyMedium?.copyWith(
                          color:
                              data.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        cupertino: (data) => data.textTheme.textStyle.copyWith(
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PlatformElevatedButton(
                  onPressed: () => context.go('/dashboard/start-session'),
                  material: (_, __) => MaterialElevatedButtonData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FFFF),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  cupertino: (_, __) => CupertinoElevatedButtonData(
                    color: const Color(0xFF00FFFF),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Start Practice',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              PlatformIconButton(
                onPressed: () => context.go('/metronome'),
                material: (_, __) => MaterialIconButtonData(
                  style: IconButton.styleFrom(
                    backgroundColor: platformThemeData(
                      context,
                      material: (data) => data.colorScheme.surface,
                      cupertino: (data) => CupertinoColors.systemBackground,
                    ),
                    foregroundColor: const Color(0xFF00FFFF),
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                cupertino: (_, __) => CupertinoIconButtonData(
                  padding: const EdgeInsets.all(12),
                ),
                icon: PlatformWidget(
                  material: (_, __) => const Icon(Icons.speed),
                  cupertino: (_, __) => const Icon(CupertinoIcons.metronome),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
