import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import '../utilities/colors.dart';

class TavaBottomNavigationBar extends StatefulWidget {
  const TavaBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<TavaBottomNavigationBar> createState() =>
      _TavaBottomNavigationBarState();
}

class _TavaBottomNavigationBarState extends State<TavaBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 5,
      animationDuration: const Duration(milliseconds: 200),
      backgroundColor: backgroundColor,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.apps),
          title: const Text('Home'),
          activeColor: statsRedColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.people),
          title: const Text('Categories'),
          activeColor: statsGreenColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.message),
          title: const Text(
            'Journey',
          ),
          activeColor: statsBlueColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.settings),
          title: const Text('Settings'),
          activeColor: statsYellowColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
