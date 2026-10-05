# Tava

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Practice journal and metronome for musicians.

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# One-time: copy secrets (gitignored) — use the sb_publishable_... key
$ cp dart_defines.example.json dart_defines.json
# edit dart_defines.json and set SUPABASE_ANON_KEY

# Development
$ flutter run --flavor development --target lib/main_development.dart \
    --dart-define-from-file=dart_defines.json

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart \
    --dart-define-from-file=dart_defines.json

# Production
$ flutter run --flavor production --target lib/main_production.dart \
    --dart-define-from-file=dart_defines.json

# TestFlight IPA
$ ./scripts/ios_archive.sh production
```

_\*Tava works on iOS, Android, Web, and Windows. Always pass `--dart-define-from-file=dart_defines.json` — without it the Supabase key is empty and login fails. Do not use the legacy JWT `anon` key; this project has those disabled._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. Open `lib/l10n/arb/app_en.arb` and add a key with a description:

```arb
{
  "@@locale": "en",
  "appTitle": "Tava",
  "@appTitle": {
    "description": "Application title shown in the OS task switcher"
  },
  "practiceCta": "Practice",
  "@practiceCta": {
    "description": "Primary call to action to start a practice session"
  }
}
```

2. Add the Spanish translation in `lib/l10n/arb/app_es.arb`.

3. Use the string via the `context.l10n` extension:

```dart
import 'package:tava/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.practiceCta);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

Keep keys in sync across locales under `lib/l10n/arb/`. Current seed keys:

`app_en.arb`

```arb
{
  "@@locale": "en",
  "appTitle": "Tava",
  "@appTitle": {
    "description": "Application title shown in the OS task switcher and splash branding"
  }
}
```

`app_es.arb`

```arb
{
  "@@locale": "es",
  "appTitle": "Tava",
  "@appTitle": {
    "description": "Título de la aplicación en el conmutador de tareas y el splash"
  }
}
```

### Generating Translations

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style:very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
