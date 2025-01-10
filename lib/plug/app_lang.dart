import 'app_lang_platform_interface.dart';

class AppLang {
  Future<String?> getPhoneLanguage() {
    return AppLangPlatform.instance.getPhoneLanguage();
  }
}
