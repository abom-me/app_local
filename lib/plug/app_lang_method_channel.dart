import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_lang_platform_interface.dart';

/// An implementation of [AppLangPlatform] that uses method channels.
class MethodChannelAppLang extends AppLangPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_lang');

  @override
  Future<String?> getPhoneLanguage() async {
    if (kIsWeb) {
      return "en-OM";
    }

    try {
      if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
        final version =
            await methodChannel.invokeMethod<String>('getPhoneLanguage');
        return version;
      }
      return "en-OM";
    } catch (e) {
      return "en-OM";
    }
  }
}
