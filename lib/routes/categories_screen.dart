import 'package:flutter/material.dart';
import '../utilities/colors.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainCardBackgroundColor,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'CATEGORIES',
            textAlign: TextAlign.center,
            textScaleFactor: 1.8,
          ),
        ),
      ),
    );
  }
}
