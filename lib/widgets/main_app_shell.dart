import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tava/utilities/colors.dart';
import '../widgets/bottom_navigation.dart';

class MainAppShell extends ConsumerWidget {
  const MainAppShell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef watch) {
    return Scaffold(
      backgroundColor: Colors.red,
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
      bottomNavigationBar: TavaBottomNavigationBar(
        menuScreenContext: context,
      ),
    );
  }
}
