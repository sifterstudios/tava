import 'package:flutter/widgets.dart';
import 'package:tava/l10n/arb/app_localizations.dart';

export 'package:tava/l10n/arb/app_localizations.dart';

/// Extension on [BuildContext] to access the localized strings.
extension AppLocalizationsX on BuildContext {
  /// Returns the localized strings for the current context.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
