import 'package:flutter/material.dart';

class BpmSlider extends StatelessWidget {
  const BpmSlider({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Slider(
          value: value.clamp(30, 300),
          min: 30,
          max: 300,
          divisions: 270,
          label: '${value.round()} BPM',
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('30', style: theme.textTheme.bodySmall),
            Text('300', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            _BpmButton(
              icon: Icons.remove,
              semanticLabel: 'Decrease BPM by 1',
              onPressed: () => onChanged(value - 1),
            ),
            _BpmButton(
              icon: Icons.remove,
              label: '5',
              semanticLabel: 'Decrease BPM by 5',
              onPressed: () => onChanged(value - 5),
            ),
            _BpmButton(
              icon: Icons.add,
              label: '5',
              semanticLabel: 'Increase BPM by 5',
              onPressed: () => onChanged(value + 5),
            ),
            _BpmButton(
              icon: Icons.add,
              semanticLabel: 'Increase BPM by 1',
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }
}

class _BpmButton extends StatelessWidget {
  const _BpmButton({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.label,
  });

  final IconData icon;
  final String? label;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(label!),
            ],
          ],
        ),
      ),
    );
  }
}
