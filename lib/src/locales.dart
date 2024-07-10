import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import '../app_local.dart';

// Main Locales class to manage localization
class Locales {
  static late Locale selectedLocale;
  static late String _path;
  static late List<Locale> supportedLocales;

  final Locale locale;
  Locales(this.locale, {bool initialize = true}) {
    if (initialize) selectedLocale = locale;
  }

  // Getters
  static String get lang => selectedLocale.languageCode;
  static String get path => _path;

  static bool get selectedLocaleRtl => selectedLocale.languageCode != 'en';

  static Locales? of(BuildContext context) {
    return Localizations.of<Locales>(context, Locales);
  }

  static bool isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
  }

  static Future<void> init({
    required List<String> localeNames,
    required String localPath,
  }) async {
    try {
      supportedLocales = localeNames.map((name) => Locale(name)).toList();
      _path = localPath;
      final pref = await PreferenceUtils.init();
      log('Selected Language: ${pref.locale}',name: "🌍 App Local 🌍");
      Locales.selectedLocale = pref.locale ?? supportedLocales.first;
    } catch (e) {
      log('Error while loading locale: $e');
    }
  }

  static void change(BuildContext context, String lang) {
    LocaleNotifier.of(context)!.change(lang);
  }

  static Locale? currentLocale(BuildContext context) {
    return LocaleNotifier.of(context)!.locale;
  }

  // Localization delegates
  static const LocalizationsDelegate<Locales> delegate = _LocalesDelegate();

  static const delegates = [
    Locales.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  Map<String, String> _localizedStrings = HashMap();

  Future<void> load() async {
    String lng = locale.languageCode;
    String jsonString = await rootBundle.loadString("$_path$lng.json");
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String get(String key, [List<String>? params, List<String>? localeParams]) {
    key = key.replaceAll(" ", "_").toLowerCase();
    String localizedString = _localizedStrings[key] ?? "\$$key";
    bool localizeParams = localeParams != null;
    if (localeParams != null) {
      params = localeParams;
    }

    if (params != null && params.isNotEmpty) {
      for (int i = 0; i < params.length; i++) {
        String placeholder = "#" * (i + 1);
        final param = params[i];
        final localizedParam = localizeParams ? _localizedStrings[param.replaceAll(' ', '_').toLowerCase()] : param;
        if (localizedParam != null) localizedString = localizedString.replaceFirst(placeholder, localizedParam);
      }
      localizedString = localizedString.replaceAll("#", "");
    }
    return localizedString;
  }

  static String string(
      BuildContext context,
      String key, {
        List<String>? params,
        List<String>? localeParams,
      }) {
    return Localizations.of<Locales>(context, Locales)!.get(
      key,
      params,
      localeParams,
    );
  }
}

// Delegate class for Locales
class _LocalesDelegate extends LocalizationsDelegate<Locales> {
  const _LocalesDelegate();

  @override
  bool isSupported(Locale locale) {
    return Locales.supportedLocales.any((supportedLocale) => supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<Locales> load(Locale locale) async {
    Locales localization = Locales(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<Locales> old) {
    return false;
  }
}
