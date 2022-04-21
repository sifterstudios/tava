import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tava/routes/categories_screen.dart';
import 'package:tava/routes/journey_screen.dart';
import 'package:tava/routes/notifications_screen.dart';
import 'package:tava/routes/settings_screen.dart';
import 'package:tava/routes/tava_screen.dart';
import 'package:tava/utilities/flex_scheme_data.dart';
import 'package:tava/utilities/main_text_theme.dart';
import 'package:tava/widgets/main_app_shell.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init((options) {
    options.dsn =
        'https://245c7e355fe2458088dabf045e2004ab@o1191596.ingest.sentry.io/6313047';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
  }, appRunner: () => runApp(ProviderScope(child: TavaApp())));
}

class TavaApp extends StatelessWidget {
  TavaApp({Key? key}) : super(key: key);
  static final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  final router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (kDebugMode) {
              print('You have an error! ${snapshot.error.toString()}');
            }
            return const Text('Something went wrong!');
          } else if (snapshot.hasData) {
            return const MainAppShell();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ),
    GoRoute(
      path: '/tava',
      builder: (context, state) => const Tava(),
    ),
    GoRoute(
        path: '/categories', builder: (context, state) => const Categories()),
    GoRoute(path: '/journey', builder: (context, state) => const Journey()),
    GoRoute(path: '/settings', builder: (context, state) => const Settings()),
    GoRoute(
        path: '/notifications',
        builder: (context, state) => const Notifications()),
  ]);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.dark(
          colors: tavaFlexScheme.dark,
          textTheme: tavaTextTheme,
          primaryTextTheme: tavaTextTheme),
    );
  }
}
