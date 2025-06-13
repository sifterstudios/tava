import 'package:flutter/material.dart';

class TimeSignatureSelector extends StatelessWidget {
  final int beatsPerMeasure;
  final int beatUnit;
  final Function(int, int) onChanged;

  const TimeSignatureSelector({
    super.key,
    required this.beatsPerMeasure,
    required this.beatUnit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TimeSignatureDropdown(
          value: beatsPerMeasure,
          items: const [2, 3, 4, 5, 6, 7, 8, 9, 12],
          onChanged: (value) {
            if (value != null) {
              onChanged(value, beatUnit);
            }
          },
        ),
        const Text('/'),
        _TimeSignatureDropdown(
          value: beatUnit,
          items: const [2, 4, 8, 16],
          onChanged: (value) {
            if (value != null) {
              onChanged(beatsPerMeasure, value);
            }
          },
        ),
      ],
    );
  }
}

class _TimeSignatureDropdown extends StatelessWidget {
  final int value;
  final List<int> items;
  final ValueChanged<int?> onChanged;

  const _TimeSignatureDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<int>(
          value: item,
          child: Text('$item'),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}