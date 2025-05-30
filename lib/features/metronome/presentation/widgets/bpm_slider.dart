import 'package:flutter/material.dart';

class BpmSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const BpmSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Slider(
          value: value,
          min: 30,
          max: 300,
          divisions: 270,
          onChanged: onChanged,
          activeColor: theme.colorScheme.primary,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('30', style: theme.textTheme.bodySmall),
            Text('300', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BpmButton(
              icon: Icons.remove,
              onPressed: () => onChanged(value - 1),
            ),
            const SizedBox(width: 8),
            _BpmButton(
              icon: Icons.remove,
              label: '5',
              onPressed: () => onChanged(value - 5),
            ),
            const SizedBox(width: 16),
            _BpmButton(
              icon: Icons.add,
              label: '5',
              onPressed: () => onChanged(value + 5),
            ),
            const SizedBox(width: 8),
            _BpmButton(
              icon: Icons.add,
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }
}

class _BpmButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;

  const _BpmButton({
    required this.icon,
    this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(40, 40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          if (label != null) ...[
            const SizedBox(width: 4),
            Text(label!),
          ],
        ],
      ),
    );
  }
}