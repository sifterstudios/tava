import 'package:flutter/material.dart';

import '../utilities/colors.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainCardBackgroundColor,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'SETTINGS',
            textAlign: TextAlign.center,
            textScaleFactor: 1.8,
          ),
        ),
      ),
    );
  }
}
