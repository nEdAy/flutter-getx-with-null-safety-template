import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}
