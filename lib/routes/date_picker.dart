import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:tava/utilities/colors.dart';
import 'package:tava/utilities/main_text_theme.dart';

class DatePickerHorizontal extends StatefulWidget {
  const DatePickerHorizontal({Key? key}) : super(key: key);

  @override
  State<DatePickerHorizontal> createState() => _DatePickerHorizontalState();
}

class _DatePickerHorizontalState extends State<DatePickerHorizontal> {
  DateTime? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        selectionColor: fabColor,
        selectedTextColor: primaryTextColor,
        deactivatedColor: mainCardBackgroundColor,
        dateTextStyle: tavaTextTheme.bodyLarge!,
        dayTextStyle: tavaTextTheme.labelSmall!,
        monthTextStyle: const TextStyle(color: Color(0x00FFFFFF)),
        width: 60,
        height: 80,
        onDateChange: (date) {
          setState(() {
            _selectedValue = date;
          });
        },
      )
    ]);
  }
}
