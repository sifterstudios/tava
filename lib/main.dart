import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:tava/utilities/flex_scheme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexThemeData.light(colors: tavaFlexScheme.dark),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TAVA'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
        body: const Center(
          child: Text('Button pressed 0 times'),
        ),
      ),
    );
  }
}
