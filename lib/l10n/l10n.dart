import 'package:flutter/widgets.dart';

import '../gen/app_localizations.dart';

export 'package:my_tec/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
