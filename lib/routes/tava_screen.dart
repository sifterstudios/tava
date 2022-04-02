import 'package:flutter/material.dart';
import 'package:tava/utilities/colors.dart';

class Tava extends StatelessWidget {
  const Tava({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainCardBackgroundColor,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'TAVA',
            textAlign: TextAlign.center,
            textScaleFactor: 1.8,
          ),
        ),
      ),
    );
  }
}
