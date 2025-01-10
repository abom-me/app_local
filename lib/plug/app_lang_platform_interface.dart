import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_lang_method_channel.dart';

abstract class AppLangPlatform extends PlatformInterface {
  /// Constructs a AppLangPlatform.
  AppLangPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppLangPlatform _instance = MethodChannelAppLang();

  /// The default instance of [AppLangPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppLang].
  static AppLangPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppLangPlatform] when
  /// they register themselves.
  static set instance(AppLangPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPhoneLanguage() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
