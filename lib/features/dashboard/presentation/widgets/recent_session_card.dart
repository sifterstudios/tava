import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:tava/features/practice_session/domain/entities/practice_session.dart';

/// A card widget that displays recent practice session details.
class RecentSessionCard extends StatelessWidget {
  /// Creates a [RecentSessionCard] widget.
  const RecentSessionCard({
    required this.session,
    super.key,
  });

  /// The practice session to display.
  final PracticeSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: platformThemeData(
          context,
          material: (data) => data.colorScheme.surface,
          cupertino: (data) => CupertinoColors.systemBackground,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: platformThemeData(
            context,
            material: (data) => data.colorScheme.outline.withValues(alpha: 0.2),
            cupertino: (data) => CupertinoColors.separator,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF00FFFF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: PlatformWidget(
              material: (_, __) => const Icon(
                Icons.music_note,
                color: Color(0xFF00FFFF),
                size: 20,
              ),
              cupertino: (_, __) => const Icon(
                CupertinoIcons.music_note,
                color: Color(0xFF00FFFF),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlatformText(
                  _formatDate(session.startTime),
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    cupertino: (data) => data.textTheme.textStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                PlatformText(
                  '${_formatDuration(session.duration)} • '
                  '${session.exercises.length} exercises',
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
            ),
          ),
          PlatformWidget(
            material: (_, __) => Icon(
              Icons.chevron_right,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
            cupertino: (_, __) => const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.tertiaryLabel,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
