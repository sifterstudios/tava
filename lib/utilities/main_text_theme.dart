import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tava/utilities/colors.dart';

TextTheme tavaTextTheme = GoogleFonts.josefinSansTextTheme().copyWith(
  labelLarge: GoogleFonts.firaSans(
    textStyle: GoogleFonts.firaSansTextTheme().labelLarge,
  ),
  labelMedium: GoogleFonts.firaSans(
      textStyle: GoogleFonts.firaSansTextTheme().labelMedium,
      color: primaryTextColor),
  labelSmall: GoogleFonts.firaSans(
      textStyle: GoogleFonts.firaSansTextTheme().labelSmall,
      color: primaryTextColor),
  bodyLarge: GoogleFonts.firaSans(
      textStyle: GoogleFonts.firaSansTextTheme().bodyLarge,
      color: primaryTextColor),
  bodyMedium: GoogleFonts.firaSans(
      textStyle: GoogleFonts.firaSansTextTheme().bodyMedium,
      color: primaryTextColor),
  bodySmall: GoogleFonts.firaSans(
      textStyle: GoogleFonts.firaSansTextTheme().bodySmall,
      color: primaryTextColor),
);
