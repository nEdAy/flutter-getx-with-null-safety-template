import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'channel_keys.dart';

class GetFlavorInfo {
  static const MethodChannel _channel =
      MethodChannel(ChannelKeys.getFlavorInfo);

  static const _getFlavorInfo = 'getFlavorInfo';

  static Future<Map<String, dynamic>?> getFlavorInfo() async {
    try {
      final flavorInfo = await _channel.invokeMethod(_getFlavorInfo);
      Logger().d('flavorInfo: $flavorInfo');
      final flavorInfoMap = jsonDecode(flavorInfo);
      return flavorInfoMap;
    } on PlatformException catch (e) {
      Logger().e(e);
      return null;
    } on MissingPluginException catch (e) {
      Logger().e(e);
      return null;
    }
  }
}
