import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tava/utilities/colors.dart';

class StatsMiniCardPanel extends StatelessWidget {
  final Color gaugeColor;

  const StatsMiniCardPanel({Key? key, required this.gaugeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: mainCardBackgroundColor,
      ),
      height: 80,
      width: 85,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SfLinearGauge(
            showLabels: false,
            minimum: 0,
            maximum: 1,
            animateRange: true,
            showTicks: false,
            showAxisTrack: false,
            ranges: [
              const LinearGaugeRange(
                color: thirdTextColor,
                startValue: 0,
                endValue: 1,
              ),
              LinearGaugeRange(
                color: gaugeColor,
                startValue: 0,
                endValue: 0.5,
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "1765",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "/2631",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Text(
            "Kcal",
            style: Theme.of(context).textTheme.bodyMedium,
            textScaleFactor: 0.7,
          )
        ],
      ),
    );
  }
}
