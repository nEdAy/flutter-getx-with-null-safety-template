import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'channel_keys.dart';

class BackToNativeChannel {
  static const MethodChannel _channel = MethodChannel(ChannelKeys.backToNative);

  static const _backToNative = 'backToNative';

  static Future<void> backToNative({bool isLogout = false}) async {
    try {
      final arguments = <String, dynamic>{
        'isLogout': isLogout,
      };
      await _channel.invokeMethod(_backToNative, arguments);
    } on PlatformException catch (e) {
      Logger().e(e);
    }
  }
}
