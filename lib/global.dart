import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

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

    // 等待服务初始化.
    _initServices();

    // // 显示悬浮按钮
    // showDebugBtn(Get.overlayContext!, btnColor: Colors.blue);
  }

  /// 在你运行Flutter应用之前，让你的服务初始化是一个明智之举。
  /// 因为你可以控制执行流程（也许你需要加载一些主题配置，apiKey，由用户自定义的语言等，所以在运行ApiService之前加载SettingService。
  /// 所以GetMaterialApp()不需要重建，可以直接取值。
  static void _initServices() async {
    Logger().i('starting services ...');
    /// 这里是你放get_storage、hive、shared_pref初始化的地方。
    /// 或者moor连接，或者其他什么异步的东西。
    await Get.putAsync(() => DbService().init());
    Logger().i('All services started...');
  }
}

class DbService extends GetxService {
  Future<DbService> init() async {
    Logger().i('$runtimeType delays 2 sec');
    await 2.delay();
    Logger().i('$runtimeType ready!');
    return this;
  }
}
