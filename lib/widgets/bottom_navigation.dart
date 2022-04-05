import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:tava/routes/categories_screen.dart';
import 'package:tava/routes/journey_screen.dart';
import 'package:tava/routes/settings_screen.dart';
import 'package:tava/utilities/main_text_theme.dart';

import '../routes/home_screen.dart';
import '../routes/tava_screen.dart';
import '../utilities/colors.dart';

class TavaBottomNavigationBar extends StatefulWidget {
  final BuildContext menuScreenContext;
  const TavaBottomNavigationBar({Key? key, required this.menuScreenContext})
      : super(key: key);

  @override
  _TavaBottomNavigationBarState createState() =>
      _TavaBottomNavigationBarState();
}

class _TavaBottomNavigationBarState extends State<TavaBottomNavigationBar> {
  late PersistentTabController _controller;
  late bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return const [
      Home(),
      Categories(),
      Tava(),
      Journey(),
      Settings(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const FaIcon(FontAwesomeIcons.houseChimneyWindow),
          title: "Home",
          activeColorPrimary: backgroundColor,
          inactiveColorPrimary: gridColor,
          textStyle: tavaTextTheme.labelSmall),
      PersistentBottomNavBarItem(
          icon: const FaIcon(FontAwesomeIcons.barsProgress),
          title: ("Exercises"),
          activeColorPrimary: backgroundColor,
          inactiveColorPrimary: gridColor,
          textStyle: tavaTextTheme.labelSmall),
      PersistentBottomNavBarItem(
          icon: const FaIcon(FontAwesomeIcons.plus),
          iconSize: 40,
          title: ("TAVA"),
          activeColorPrimary: const Color(0xFFa84b5b),
          activeColorSecondary: secondaryTextColor,
          inactiveColorPrimary: gridColor,
          textStyle: tavaTextTheme.labelSmall),
      PersistentBottomNavBarItem(
          icon: const FaIcon(FontAwesomeIcons.personRunning),
          title: ("Journey"),
          activeColorPrimary: backgroundColor,
          inactiveColorPrimary: gridColor,
          textStyle: tavaTextTheme.labelSmall),
      PersistentBottomNavBarItem(
          icon: const FaIcon(FontAwesomeIcons.gears),
          title: ("Settings"),
          activeColorPrimary: backgroundColor,
          inactiveColorPrimary: gridColor,
          textStyle: tavaTextTheme.labelSmall),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      drawer: Drawer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text('This is the Drawer'),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.red,
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: fabColor,
        resizeToAvoidBottomInset: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        margin: const EdgeInsets.all(0.0),
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 0.0,
        onWillPop: (context) async {
          await showDialog(
            context: context!,
            useSafeArea: true,
            builder: (context) => Container(
              height: 50.0,
              width: 50.0,
              color: Colors.white,
              child: ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
          return false;
        },
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
          colorBehindNavBar: backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style16, // Choose the nav bar style with this property
      ),
    );
  }
}
