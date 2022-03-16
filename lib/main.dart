import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ThemeData Demo'),
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
