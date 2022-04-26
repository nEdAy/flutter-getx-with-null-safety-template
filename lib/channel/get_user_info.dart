import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'channel_keys.dart';

class GetUserInfo {
  static const MethodChannel _channel = MethodChannel(ChannelKeys.getUserInfo);

  static const _getUserInfo = 'getUserInfo';

  static Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final userInfo = await _channel.invokeMethod(_getUserInfo);
      final userInfoMap = jsonDecode(userInfo);
      return userInfoMap;
    } on PlatformException catch (e) {
      Logger().e(e);
      return null;
    }
  }
}
