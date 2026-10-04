import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickStartCard extends StatelessWidget {
  const QuickStartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => context.push('/session'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                Icons.play_circle_filled_rounded,
                size: 48,
                color: colors.onPrimary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start a practice session',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Log exercises, tempo, and how the session felt',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onPrimary.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
