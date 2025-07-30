import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'config/package_info_config.dart';
import 'config/device_info_config.dart';
import 'env/env_switcher.dart';
import 'store/store_manager.dart';
import 'utils/error_utils.dart';

const appName = 'Template';
const defaultDesignSize = Size(360, 690);

const apiUrl = "api_url";
const productionBaseUrl = 'https://v1.hitokoto.cn/';
const testingBaseUrl = 'https://international.v1.hitokoto.cn';

final talker = TalkerFlutter.init();

/// Global configuration
class Global {
  /// init
  static Future<dynamic> init() async {
    // Ensure initialization
    WidgetsFlutterBinding.ensureInitialized();

    // Android status bar is transparent immersion
    if (!kIsWeb && Platform.isAndroid) {
      const systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    // Service Initialization
    await ConfigService().init();
    await EnvService().init();
    await StoreService().init();
  }
}

class ConfigService {
  Future<void> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    PackageInfoConfig(packageInfo);

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo? androidInfo;
    IosDeviceInfo? iosInfo;
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
    }
    if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;
    }
    DeviceInfoConfig(androidInfo: androidInfo, iosInfo: iosInfo);

    ErrorUtils.configureTag();
  }
}

class EnvService {
  Future<void> init() async {
    /// Initializes the environment switcher and loads the last saved environment.
    EnvSwitcher.loadCurrentEnv();
    EnvSwitcher.addEnvironment(DefaultEnv.production.name, {
      apiUrl: productionBaseUrl,
    });
    EnvSwitcher.addEnvironment(DefaultEnv.staging.name, {
      apiUrl: testingBaseUrl,
    });
    EnvSwitcher.addEnvironment(DefaultEnv.development.name, {
      apiUrl: testingBaseUrl,
    });
  }
}

class StoreService {
  Future<void> init() async {
    final SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
          cacheOptions: const SharedPreferencesWithCacheOptions(),
        );
    StoreManager(pref: prefsWithCache);
  }
}
