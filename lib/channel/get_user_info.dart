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
      Logger().d("userInfo: $userInfo");
      final userInfoMap = jsonDecode(userInfo);
      return userInfoMap;
    } on PlatformException catch (e) {
      Logger().e(e);
      return null;
    } on MissingPluginException catch (e) {
      Logger().e(e);
      return null;
    }
  }

  static String _lastAccessToken = '';

  static String getLastAccessToken() {
    return _lastAccessToken;
  }

  static void setLastAccessToken(String token) {
    _lastAccessToken = token;
  }
}
