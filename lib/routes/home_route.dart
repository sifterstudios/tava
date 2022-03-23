import 'package:flutter/material.dart';
import 'package:tava/routes/date_picker.dart';
import 'package:tava/utilities/colors.dart';
import 'package:tava/utilities/main_text_theme.dart';

import '../widgets/stats_mini_card_panel.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'TAVA',
            textAlign: TextAlign.center,
            textScaleFactor: 1.8,
          ),
        ),
        actions: const [
          Icon(Icons.notifications_none_outlined),
          SizedBox(
            width: 15,
            height: 15,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          const DatePickerHorizontal(),
          const SizedBox(
            height: 25,
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: cardBackgroundColor),
            height: 150,
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            child: Center(
              child: Wrap(
                spacing: 90,
                children: [
                  StatsMiniCardPanel(
                    gaugeColor: statsRedColor,
                  ),
                  StatsMiniCardPanel(
                    gaugeColor: statsGreenColor,
                  ),
                  StatsMiniCardPanel(
                    gaugeColor: statsBlue,
                  ),
                  StatsMiniCardPanel(
                    gaugeColor: statsYellowColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            "Breakfast",
            style: Theme.of(context).textTheme.headlineLarge,
          )
        ],
      ),
    );
  }
}
