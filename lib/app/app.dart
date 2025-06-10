import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tava/app/routes/router.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tava/features/settings/presentation/bloc/settings_bloc.dart';

/// The main entry point of the Tava application.
class App extends StatelessWidget {
  /// Creates an instance of the App widget.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()..add(CheckAuthStatus())),
        BlocProvider(create: (_) => getIt<SettingsBloc>()..add(LoadSettings())),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode,
        builder: (context, state) {
          return PlatformProvider(
            settings: PlatformSettingsData(
              iosUseZeroPaddingForAppbarPlatformIcon: true,
            ),
            builder: (context) => PlatformApp.router(
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
              title: 'Tava',
              material: (_, __) => MaterialAppRouterData(
                theme: _buildMaterialLightTheme(),
                darkTheme: _buildMaterialDarkTheme(),
                themeMode: state.themeMode,
              ),
              cupertino: (_, __) => CupertinoAppRouterData(
                theme: _buildCupertinoTheme(state.themeMode),
              ),
            ),
          );
        },
      ),
    );
  }

  ThemeData _buildMaterialLightTheme() {
    return FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: Color(0xFF00FFFF),
        primaryContainer: Color(0xFF8DFFFF),
        secondary: Color(0xFF6200EA),
        secondaryContainer: Color(0xFFB388FF),
        tertiary: Color(0xFF00BFA5),
        tertiaryContainer: Color(0xFF64FFDA),
        appBarColor: Color(0xFF00FFFF),
      ),
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 10,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        inputDecoratorRadius: 8,
        cardRadius: 8,
        defaultRadius: 8,
        dialogRadius: 8,
        timePickerElementRadius: 8,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: _buildTextTheme(),
    );
  }

  ThemeData _buildMaterialDarkTheme() {
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: Color(0xFF00FFFF),
        primaryContainer: Color(0xFF007E80),
        secondary: Color(0xFFBB86FC),
        secondaryContainer: Color(0xFF4A148C),
        tertiary: Color(0xFF64FFDA),
        tertiaryContainer: Color(0xFF004D40),
        appBarColor: Color(0xFF00FFFF),
      ),
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 15,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        inputDecoratorRadius: 8,
        cardRadius: 8,
        defaultRadius: 8,
        dialogRadius: 8,
        timePickerElementRadius: 8,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: _buildTextTheme(),
    );
  }

  CupertinoThemeData _buildCupertinoTheme(ThemeMode themeMode) {
    final isDark = themeMode == ThemeMode.dark;

    return CupertinoThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: const Color(0xFF00FFFF),
      primaryContrastingColor:
          isDark ? CupertinoColors.black : CupertinoColors.white,
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
      barBackgroundColor:
          isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF9F9F9),
      textTheme: CupertinoTextThemeData(
        primaryColor: const Color(0xFF00FFFF),
        textStyle: GoogleFonts.inter(
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
        ),
        navTitleTextStyle: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
        ),
        navLargeTitleTextStyle: GoogleFonts.inter(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
        ),
      ),
    );
  }

  TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.manrope(
          fontSize: 57, fontWeight: FontWeight.w700, letterSpacing: -0.25),
      displayMedium: GoogleFonts.manrope(
          fontSize: 45, fontWeight: FontWeight.w700, letterSpacing: 0),
      displaySmall: GoogleFonts.manrope(
          fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: 0),
      headlineLarge: GoogleFonts.manrope(
          fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: 0),
      headlineMedium: GoogleFonts.manrope(
          fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 0),
      headlineSmall: GoogleFonts.manrope(
          fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 0),
      titleLarge: GoogleFonts.inter(
          fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 0),
      titleMedium: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
      titleSmall: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      bodyLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
      bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      bodySmall: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    );
  }
}
