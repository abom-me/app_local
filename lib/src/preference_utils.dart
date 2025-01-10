import 'package:app_local/plug/app_lang.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './locales.dart';

class PreferenceUtils {
  static String deviceLocale = "";
  late SharedPreferences prefs;
  static late PreferenceUtils instance;
  static Future<PreferenceUtils> init() async {
    PreferenceUtils.instance = PreferenceUtils();
    deviceLocale =
        (await AppLang().getPhoneLanguage() ?? "en").split("-").first;
    instance.prefs = await SharedPreferences.getInstance();
    return instance;
  }

  setLocale(String lng) {
    prefs.setString('language', lng);

    if (lng == 'auto') {
      final deviceLocale = Locale(PreferenceUtils.deviceLocale);

      Locales.selectedLocale = Locales.supportedLocales.contains(deviceLocale)
          ? deviceLocale
          : Locales.supportedLocales.first;
    } else {
      Locales.selectedLocale = Locale(lng);
    }
  }

  Locale? get locale {
    try {
      final localeName = prefs.getString('language');
      if (Locales.isPhoneLocalee == true && localeName == null) {
        return Locales.supportedLocales
                .contains(Locale(PreferenceUtils.deviceLocale))
            ? Locale(PreferenceUtils.deviceLocale)
            : Locales.supportedLocales.first;
      }
      if (localeName == null) return Locales.supportedLocales.first;
      if (localeName == 'auto') {
        final deviceLocale = Locale(PreferenceUtils.deviceLocale);
        // Check if device locale is supported, otherwise return first supported locale
        return Locales.supportedLocales.contains(deviceLocale)
            ? deviceLocale
            : Locales.supportedLocales.first;
      }
      return Locale(localeName);
    } catch (e) {
      return Locales.supportedLocales.first;
    }
  }
}
