import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../config/flavor.dart';
import '../routes/app_pages.dart';
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
    } on MissingPluginException catch (e) {
      Logger().e(e);
      final currentRoute = Get.currentRoute;
      if (FlavorConfig.isUAT() && kDebugMode && currentRoute != Routes.login) {
        await Get.offAndToNamed(
          Routes.login,
          arguments: {
            'route': Get.currentRoute,
            'arguments': Get.arguments,
          },
        );
      }
    }
  }
}
