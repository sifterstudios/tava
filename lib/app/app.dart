import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tava/app/routes/router.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tava/features/settings/presentation/bloc/settings_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthBloc _authBloc;
  late final SettingsBloc _settingsBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>()..add(CheckAuthStatus());
    _settingsBloc = getIt<SettingsBloc>()..add(LoadSettings());
    _router = createAppRouter(_authBloc);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _settingsBloc),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode,
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Tava',
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: state.themeMode,
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    // Deep teal keeps WCAG contrast on light surfaces while preserving the
    // cyan musical identity through containers and accents.
    return FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: Color(0xFF0B6E75),
        primaryContainer: Color(0xFFB2F0F3),
        secondary: Color(0xFF5B21B6),
        secondaryContainer: Color(0xFFE9D5FF),
        tertiary: Color(0xFF0F766E),
        tertiaryContainer: Color(0xFFCCFBF1),
        appBarColor: Color(0xFF0B6E75),
      ),
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 6,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 8,
        inputDecoratorRadius: 14,
        cardRadius: 14,
        dialogRadius: 18,
        timePickerElementRadius: 12,
        filledButtonRadius: 14,
        elevatedButtonRadius: 14,
        outlinedButtonRadius: 14,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarIndicatorSchemeColor: SchemeColor.primaryContainer,
        defaultRadius: 14,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: _textTheme(),
    );
  }

  ThemeData _buildDarkTheme() {
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: Color(0xFF3DD6DA),
        primaryContainer: Color(0xFF0C3F42),
        secondary: Color(0xFFC4B5FD),
        secondaryContainer: Color(0xFF3B0764),
        tertiary: Color(0xFF5EEAD4),
        tertiaryContainer: Color(0xFF115E59),
        appBarColor: Color(0xFF0C3F42),
      ),
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 10,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 18,
        inputDecoratorRadius: 12,
        cardRadius: 12,
        dialogRadius: 16,
        timePickerElementRadius: 12,
        filledButtonRadius: 12,
        elevatedButtonRadius: 12,
        outlinedButtonRadius: 12,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarIndicatorSchemeColor: SchemeColor.primaryContainer,
        defaultRadius: 12,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: _textTheme(),
    );
  }

  TextTheme _textTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.manrope(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.manrope(
        fontSize: 45,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: GoogleFonts.manrope(
        fontSize: 36,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );
  }
}
