import 'package:flutter/material.dart';
import '../utilities/colors.dart';

class Journey extends StatelessWidget {
  const Journey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainCardBackgroundColor,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'JOURNEY',
            textAlign: TextAlign.center,
            textScaleFactor: 1.8,
          ),
        ),
      ),
    );
  }
}
