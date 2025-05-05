import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:app_local/plug/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import '../app_local.dart';
import 'locales_delegate.dart';
import 'string_utils.dart';

/// Manages localization for the application
class Locales {
  // Static fields
  static late Locale selectedLocale;
  static late String _path;
  static late List<Locale> supportedLocales;
  static late String deviceLocale = "en-OM";
  static late bool isPhoneLocalee;

  // Instance fields
  final Locale locale;
  final Map<String, String> _localizedStrings = HashMap();

  // Constructor
  Locales(this.locale, {bool initialize = true}) {
    assert(
      supportedLocales.contains(locale),
      'Locale ${locale.languageCode} is not supported. '
      'Supported locales are: ${supportedLocales.map((l) => l.languageCode).join(", ")}',
    );
    if (initialize) selectedLocale = locale;
  }

  // Static getters
  static String get lang => selectedLocale.languageCode;
  static String get path => _path;
  static bool get selectedLocaleRtl => selectedLocale.languageCode != 'en';

  // Localization delegates
  static const LocalizationsDelegate<Locales> delegate = LocalesDelegate();
  static const delegates = [
    Locales.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// Initialize localization settings
  ///
  ///  📝 localPath: is the path to the localization files example: "assets/lang/"
  ///
  ///  📝 localeNames: is the list of supported locales example: ["en", "ar"]
  ///
  ///  📝 phoneLocale: is the flag to use the phone language as the default language in the first time
  static Future<void> init({
    required List<String> localeNames,
    required String localPath,
    bool? phoneLocale,
  }) async {
    isPhoneLocalee = phoneLocale ?? false;
    try {
      if (localeNames.isEmpty) {
        throw ArgumentError('localeNames cannot be empty');
      }

      _path = localPath.endsWith('/') ? localPath : '$localPath/';
      supportedLocales = localeNames.map((name) => Locale(name)).toList();
      deviceLocale =
          (await AppLang().getPhoneLanguage() ?? "en-OM").split("-").first;
      final pref = await PreferenceUtils.init();
      selectedLocale = phoneLocale == true
          ? _determineInitialLocale()
          : (pref.locale ?? _determineInitialLocale());

      log('Selected Language: ${selectedLocale.languageCode}',
          name: "🌍 App Local 🌍");
    } catch (e) {
      log('Error while loading locale: $e');
    }
  }

  static Locale _determineInitialLocale() {
    final deviceLocale1 = Locale(deviceLocale);
    return supportedLocales.contains(deviceLocale1)
        ? deviceLocale1
        : supportedLocales.first;
  }

  Future<void> load() async {
    try {
      final jsonString =
          await rootBundle.loadString("$_path${locale.languageCode}.json");
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      _localizedStrings
          .addAll(jsonMap.map((key, value) => MapEntry(key, value.toString())));
    } catch (e) {
      log('Error loading localization file: $e', name: "🌍 App Local 🌍");
    }
  }

  String get(
    String key, [
    List<String>? params,
    List<String>? localeParams,
  ]) {
    final normalizedKey = StringUtils.normalizeKey(key);
    var localizedString =
        _localizedStrings[normalizedKey] ?? "\$$normalizedKey";

    if (params?.isNotEmpty ?? false) {
      localizedString = StringUtils.replacePlaceholders(
        localizedString,
        params!,
        localeParams,
        _localizedStrings,
      );
    }

    return localizedString;
  }

  bool hasKey(String key) =>
      _localizedStrings.containsKey(StringUtils.normalizeKey(key));

  Set<String> get availableKeys => _localizedStrings.keys.toSet();

  Future<void> reload() async {
    _localizedStrings.clear();
    await load();
  }

  // Static utility methods
  static Locales? of(BuildContext context) =>
      Localizations.of<Locales>(context, Locales);

  static bool isDirectionRTL(BuildContext context) =>
      intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);

  static void change(BuildContext context, String lang) {
    LocaleNotifier.of(context)?.change(lang);
  }

  static Locale? currentLocale(BuildContext context) =>
      LocaleNotifier.of(context)?.locale;

  static String string(
    BuildContext context,
    String key, {
    List<String>? params,
    List<String>? localeParams,
  }) =>
      Localizations.of<Locales>(context, Locales)!
          .get(key, params, localeParams);
}
