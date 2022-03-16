import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:tava/utilities/colors.dart';

FlexSchemeData tavaFlexScheme = const FlexSchemeData(
  name: 'TAVA',
  description: 'Main App Theme',
  dark: FlexSchemeColor(
    primary: Color(0xFF060912),
    primaryVariant: Color(0xFF0C111E),
    secondary: Color(0xFF0088FF),
    secondaryVariant: Color(0xFF46A8FF),
  ),
  light: FlexSchemeColor(
    primary: Color(0xFFFFFFFF),
    primaryVariant: Color(0xFFFAFAFD),
    secondary: Color(0xFF0088FF),
    secondaryVariant: Color(0xFF060912),
  ),
);

class ColorScheme {
  // ColorScheme tavaColorScheme =  ColorScheme(brightness: Brightness.dark, primary: backgroundColor, onPrimary: primaryTextColor, secondary: cardBackgroundColor, onSecondary: primaryTextColor, error: statsRedColor, onError: primaryTextColor, background: backgroundColor, onBackground: primaryTextColor, surface: cardBackgroundColor, onSurface: primaryTextColor)

}
