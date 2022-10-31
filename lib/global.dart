import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/store/store_manager.dart';
import 'package:flutter_template/store/user_info.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';

import 'channel/get_user_info.dart';
import 'config/flavor.dart';
import 'config/user_info.dart';

/// 全局配置
class Global {
  /// init
  static Future<dynamic> init() async {
    // 确保初始化
    WidgetsFlutterBinding.ensureInitialized();

    // Android 状态栏为透明的沉浸
    if (!kIsWeb && Platform.isAndroid) {
      const systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    // 等待服务初始化
    await _initServices();
  }

  /// 在你运行Flutter应用之前，让你的服务初始化是一个明智之举。
  /// 因为你可以控制执行流程（也许你需要加载一些主题配置，apiKey，由用户自定义的语言等，所以在运行ApiService之前加载SettingService。
  /// 所以GetMaterialApp()不需要重建，可以直接取值。
  static Future _initServices() async {
    Logger().i('starting services ...');

    /// 这里是你放get_storage、hive、shared_pref初始化的地方。
    /// 或者moor连接，或者其他什么异步的东西。
    await Get.putAsync(() => StoreService().init());
    await Get.putAsync(() => FlavorService().init());
    await Get.putAsync(() => UserInfoService().init());

    Logger().i('All services started...');
  }
}

class StoreService extends GetxService {
  Future<StoreService> init() async {
    final isar = await Isar.open([UserInfoSchema]);
    StoreManager(isar: isar);
    return this;
  }
}

class FlavorService extends GetxService {
  Future<FlavorService> init() async {
    final flavorInfoMap = {}; // await GetFlavorInfo.getFlavorInfo();
    final flavor = flavorInfoMap['flavor'] ?? prod;
    final baseUrl = flavorInfoMap['baseUrl'] ?? prodBaseUrl;
    FlavorConfig(flavor: flavor, values: FlavorValues(baseUrl: baseUrl));
    return this;
  }
}

class UserInfoService extends GetxService {
  Future<UserInfoService> init() async {
    final userInfoMap = await GetUserInfo.getUserInfo();
    var oaAccount = '';
    String? password;
    var token = '';
    var memberId = '';
    if (userInfoMap != null) {
      token = userInfoMap['accessToken'] ?? '';
      memberId = userInfoMap['memberId'] ?? '';
      oaAccount = userInfoMap['oaAccount'] ?? '';
    } else {
      final userInfo = StoreManager.instance.getUserInfoSync();
      if (userInfo != null) {
        oaAccount = userInfo.oaAccount ?? '';
        password = userInfo.password;
        token = userInfo.token ?? '';
        memberId = userInfo.memberId ?? '';
      }
    }
    final userInfo = UserInfo(
      oaAccount: oaAccount,
      password: password,
      token: token,
      memberId: memberId,
    );
    UserInfoConfig(userInfo: userInfo);
    return this;
  }
}
