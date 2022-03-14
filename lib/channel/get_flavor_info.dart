import 'dart:convert';

import 'package:flutter/services.dart';

import 'channel_keys.dart';

class GetFlavorInfo {
  static const MethodChannel _channel =
      MethodChannel(ChannelKeys.getFlavorInfo);

  static const _getFlavorInfo = 'getFlavorInfo';

  static Future<Map<String, dynamic>> getFlavorInfo() async {
    final flavorInfo = await _channel.invokeMethod(_getFlavorInfo);
    final flavorInfoMap = jsonDecode(flavorInfo);
    return flavorInfoMap;
  }
}
