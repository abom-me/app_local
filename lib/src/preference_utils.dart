import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './locales.dart';

class PreferenceUtils {
  late SharedPreferences prefs;
  static late PreferenceUtils instance;
  static Future<PreferenceUtils> init() async {
    PreferenceUtils.instance = PreferenceUtils();
    instance.prefs = await SharedPreferences.getInstance();
    return instance;
  }

  setLocale(String lng) {
    prefs.setString('language', lng);
    Locales.selectedLocale = Locale(lng);
  }

  Locale? get locale {
    try {
      final localeName = prefs.getString('language');
      if (localeName == null) Locales.supportedLocales.first;
      return Locale(localeName!);
    } catch (e) {
      return Locales.supportedLocales.first;
    }
  }
}
