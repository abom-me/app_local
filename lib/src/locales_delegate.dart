import 'package:flutter/material.dart';

import 'locales.dart';

/// Delegate class for Locales
class LocalesDelegate extends LocalizationsDelegate<Locales> {
  const LocalesDelegate();

  @override
  bool isSupported(Locale locale) {
    return Locales.supportedLocales.any((supportedLocale) =>
        supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<Locales> load(Locale locale) async {
    final localization = Locales(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<Locales> old) => false;
}
