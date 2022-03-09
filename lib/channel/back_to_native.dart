import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'channel_keys.dart';

class GoBackToNativeChannel {
  static const MethodChannel _channel =
      MethodChannel(ChannelKeys.goBackToNative);

  static const _goBackToNative = 'goBackToNative';

  static Future<void> goBackToNative() async {
    try {
      await _channel.invokeMethod(_goBackToNative);
    } on PlatformException catch (e) {
      Logger().e(e);
    }
  }
}
