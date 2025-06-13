import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:tava/features/progress/domain/entities/practice_stats.dart';

/// A card widget that displays practice statistics.
class PracticeStatsCard extends StatelessWidget {
  /// Creates a [PracticeStatsCard] widget.
  const PracticeStatsCard({
    super.key,
    this.stats,
  });

  /// The practice statistics to display. If null, a placeholder is shown.
  final PracticeStats? stats;

  @override
  Widget build(BuildContext context) {
    if (stats == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: platformThemeData(
            context,
            material: (data) => data.colorScheme.surface,
            cupertino: (data) => CupertinoColors.systemBackground,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: platformThemeData(
              context,
              material: (data) =>
                  data.colorScheme.outline.withValues(alpha: 0.2),
              cupertino: (data) => CupertinoColors.separator,
            ),
          ),
        ),
        child: Center(
          child: Column(
            children: [
              PlatformWidget(
                material: (_, __) => const Icon(
                  Icons.music_note,
                  size: 48,
                  color: Colors.grey,
                ),
                cupertino: (_, __) => const Icon(
                  CupertinoIcons.music_note,
                  size: 48,
                  color: CupertinoColors.inactiveGray,
                ),
              ),
              const SizedBox(height: 8),
              PlatformText(
                'No practice data yet',
                style: platformThemeData(
                  context,
                  material: (data) => data.textTheme.bodyLarge?.copyWith(
                    color: data.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  cupertino: (data) => data.textTheme.textStyle.copyWith(
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: platformThemeData(
          context,
          material: (data) => data.colorScheme.surface,
          cupertino: (data) => CupertinoColors.systemBackground,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: platformThemeData(
            context,
            material: (data) => data.colorScheme.outline.withValues(alpha: 0.2),
            cupertino: (data) => CupertinoColors.separator,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: PlatformWidget(
                    material: (_, __) =>
                        const Icon(Icons.timer, color: Color(0xFF00FFFF)),
                    cupertino: (_, __) => const Icon(CupertinoIcons.timer,
                        color: Color(0xFF00FFFF)),
                  ),
                  label: 'Total Time',
                  value: _formatDuration(stats!.totalPracticeTime),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: platformThemeData(
                  context,
                  material: (data) =>
                      data.colorScheme.outline.withValues(alpha: 0.2),
                  cupertino: (data) => CupertinoColors.separator,
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: PlatformWidget(
                    material: (_, __) => const Icon(Icons.calendar_today,
                        color: Color(0xFF00FFFF)),
                    cupertino: (_, __) => const Icon(CupertinoIcons.calendar,
                        color: Color(0xFF00FFFF)),
                  ),
                  label: 'Sessions',
                  value: stats!.totalSessions.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: platformThemeData(
              context,
              material: (data) =>
                  data.colorScheme.outline.withValues(alpha: 0.2),
              cupertino: (data) => CupertinoColors.separator,
            ),
          ),
          const SizedBox(height: 16),
          _StatItem(
            icon: PlatformWidget(
              material: (_, __) =>
                  const Icon(Icons.speed, color: Color(0xFF00FFFF)),
              cupertino: (_, __) => const Icon(CupertinoIcons.metronome,
                  color: Color(0xFF00FFFF)),
            ),
            label: 'Average BPM',
            value: stats!.averageBpm.toString(),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final Widget icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        const SizedBox(height: 8),
        PlatformText(
          value,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            cupertino: (data) => data.textTheme.navLargeTitleTextStyle.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        PlatformText(
          label,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.bodySmall?.copyWith(
              color: data.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            cupertino: (data) => data.textTheme.textStyle.copyWith(
              color: CupertinoColors.secondaryLabel,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
