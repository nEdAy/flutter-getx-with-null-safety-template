import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'channel_keys.dart';

class GoToNativeChannel {
  static const MethodChannel _channel =
      MethodChannel(ChannelKeys.goToNative);

  static const _goToNative = 'goToNative';

  static Future<void> goToNative() async {
    try {
      await _channel.invokeMethod(_goToNative);
    } on PlatformException catch (e) {
      Logger().e(e);
    } on MissingPluginException catch (e) {
      Logger().e(e);
    }
  }
}
