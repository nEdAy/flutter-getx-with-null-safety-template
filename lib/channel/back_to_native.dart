import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'channel_keys.dart';

class BackToNativeChannel {
  static const MethodChannel _channel =
      MethodChannel(ChannelKeys.backToNative);

  static const _backToNative = 'backToNative';

  static Future<void> backToNative() async {
    try {
      await _channel.invokeMethod(_backToNative);
    } on PlatformException catch (e) {
      Logger().e(e);
    }
  }
}
