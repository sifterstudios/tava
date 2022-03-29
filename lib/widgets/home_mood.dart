import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utilities/colors.dart';
import '../utilities/svg_icons.dart';

class HomeMood extends StatelessWidget {
  const HomeMood({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
        border: Border.all(
          width: 2,
          color: cardBackgroundColor,
        ),
      ),
      child: Row(
        children: [
          Text(
            "Emojis",
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SvgPicture.asset(SvgIcons.getIconPath(svgEnum.riskOfRain.index)!)
        ],
      ),
    );
  }
}
