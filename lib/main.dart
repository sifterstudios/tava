import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:tava/routes/home_route.dart';
import 'package:tava/utilities/flex_scheme_data.dart';
import 'package:tava/utilities/main_text_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.dark(
          colors: tavaFlexScheme.dark, textTheme: tavaTextTheme),
      home: const HomeRoute(),
    );
  }
}
