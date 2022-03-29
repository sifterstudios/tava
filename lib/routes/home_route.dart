import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tava/widgets/date_picker.dart';
import 'package:tava/utilities/colors.dart';
import 'package:tava/utilities/svg_icons.dart';

import '../widgets/bottom_navigation.dart';
import '../widgets/home_mood.dart';
import '../widgets/home_stats.dart';
import '../widgets/home_today.dart';
import '../widgets/stats_mini_card_panel.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainCardBackgroundColor,
      bottomNavigationBar: const TavaBottomNavigationBar(),
      drawer: const Drawer(
        backgroundColor: fabColor,
        // TODO: Add menu names to DRAWER
      ),
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
        children: const [
          SizedBox(
            height: 5,
          ),
          DatePickerHorizontal(),
          SizedBox(
            height: 5,
          ),
          HomeStats(),
          HomeToday(),
          HomeMood(),
        ],
      ),
    );
  }
}
