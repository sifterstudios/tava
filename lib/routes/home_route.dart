import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:tava/routes/date_picker.dart';
import 'package:tava/utilities/colors.dart';

import '../widgets/stats_mini_card_panel.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    var _currentIndex = 0;
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 5,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: statsRedColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.people),
            title: Text('Users'),
            activeColor: statsGreenColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.message),
            title: Text(
              'Messages test for mes teset test test ',
            ),
            activeColor: statsBlueColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: statsYellowColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
        children: [
          const SizedBox(
            height: 25,
          ),
          const DatePickerHorizontal(),
          const SizedBox(
            height: 25,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: cardBackgroundColor),
            height: 150,
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    StatsMiniCardPanel(
                      gaugeColor: statsRedColor,
                    ),
                    StatsMiniCardPanel(
                      gaugeColor: statsGreenColor,
                    ),
                    StatsMiniCardPanel(
                      gaugeColor: statsBlueColor,
                    ),
                    StatsMiniCardPanel(
                      gaugeColor: statsYellowColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            height: 150,
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: backgroundColor,
              border: Border.all(
                width: 2,
                color: cardBackgroundColor,
              ),
            ),
            child: Text(
              "Weather",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}
