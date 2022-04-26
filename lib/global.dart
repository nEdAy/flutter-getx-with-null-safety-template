import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:network_inspector/network_inspector.dart';

import 'channel/get_flavor_info.dart';
import 'config/flavor.dart';

/// 全局配置
class Global {
  /// 是否 release
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  /// init
  static Future init() async {
    // 确保初始化
    WidgetsFlutterBinding.ensureInitialized();

    // Android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    // 网络拦截器初始化
    NetworkInspector.initialize();

    // 等待服务初始化
    _initServices();
  }

  /// 在你运行Flutter应用之前，让你的服务初始化是一个明智之举。
  /// 因为你可以控制执行流程（也许你需要加载一些主题配置，apiKey，由用户自定义的语言等，所以在运行ApiService之前加载SettingService。
  /// 所以GetMaterialApp()不需要重建，可以直接取值。
  static void _initServices() async {
    Logger().i('starting services ...');

    /// 这里是你放get_storage、hive、shared_pref初始化的地方。
    /// 或者moor连接，或者其他什么异步的东西。
    await Get.putAsync(() => FlavorService().init());
    Logger().i('All services started...');
  }
}

class FlavorService extends GetxService {
  Future<FlavorService> init() async {
    final flavorInfoMap = await GetFlavorInfo.getFlavorInfo();
    final flavor = flavorInfoMap?['flavor'] ?? prod;
    final baseUrl = flavorInfoMap?['baseUrl'] ?? prodBaseUrl;
    final stage = flavorInfoMap?['stage'] ?? 'prodBaseUrl';
    FlavorConfig(
        flavor: flavor, values: FlavorValues(baseUrl: baseUrl, stage: stage));
    return this;
  }
}
