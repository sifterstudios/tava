import 'package:flutter/cupertino.dart';
import 'package:tava/widgets/stats_mini_card_panel.dart';

import '../utilities/colors.dart';

class HomeStats extends StatelessWidget {
  const HomeStats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: cardBackgroundColor),
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: StatsMiniCardPanel(
                  gaugeColor: statsRedColor,
                ),
              ),
              Expanded(
                child: StatsMiniCardPanel(
                  gaugeColor: statsGreenColor,
                ),
              ),
              Expanded(
                child: StatsMiniCardPanel(
                  gaugeColor: statsBlueColor,
                ),
              ),
              Expanded(
                child: StatsMiniCardPanel(
                  gaugeColor: statsYellowColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
