import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class DeviceInfoConfig {
  factory DeviceInfoConfig({
    required AndroidDeviceInfo? androidInfo,
    required IosDeviceInfo? iosInfo,
  }) {
    _instance = DeviceInfoConfig._internal(androidInfo, iosInfo);
    return _instance;
  }

  DeviceInfoConfig._internal(this.androidInfo, this.iosInfo);

  final AndroidDeviceInfo? androidInfo;
  final IosDeviceInfo? iosInfo;

  static late DeviceInfoConfig _instance;

  static DeviceInfoConfig get instance {
    return _instance;
  }

  static String platform() =>
      Platform.isIOS ? 'iOS' : (Platform.isAndroid ? 'Android' : 'Other');

  static String deviceModel() {
    var isAndroid = Platform.isAndroid;
    if (isAndroid) {
      return instance.androidInfo?.model ?? '';
    } else {
      return instance.iosInfo?.utsname.machine ?? '';
    }
  }

  static String deviceManufacturer() {
    var isAndroid = Platform.isAndroid;
    if (isAndroid) {
      return instance.androidInfo?.manufacturer ?? '';
    } else {
      return 'Apple';
    }
  }

  static String deviceSystemVersion() {
    var isAndroid = Platform.isAndroid;
    if (isAndroid) {
      return instance.androidInfo?.version.release ?? '';
    } else {
      return 'iOS ${instance.iosInfo?.systemVersion}';
    }
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo? data) {
    if (data == null) {
      return {};
    }
    return <String, dynamic>{
      '最新补丁日期': '${data.version.securityPatch}',
      '操作系统名': data.version.baseOS ?? '安卓',
      'sdkInt': '${data.version.sdkInt}',
      'Android版本': data.version.release,
      '手机品牌 ': data.brand,
      '手机详细版本': data.model,
      '外观设计名 ': data.device,
      '版本号': data.display,
      '当前手机唯一标识': data.fingerprint,
      '内核(单词简写)': data.hardware,
      '主机名 ': data.host,
      'id': '${data.id} ',
      'supported32BitAbis': '${data.supported32BitAbis}',
      'supported64BitAbis': '${data.supported64BitAbis}',
      'supportedAbis': '${data.supportedAbis}',
      '是否真机': '${data.isPhysicalDevice}',
    };
  }

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo? data) {
    if (data == null) {
      return {};
    }
    return <String, dynamic>{
      '设备名': data.name,
      '操作系统名': data.systemName,
      '系统版本': data.systemVersion,
      '设备型号': data.model,
      '设备名(本地)': data.localizedModel,
      '当前设备唯一值': '${data.identifierForVendor}',
      '是否真机': '${data.isPhysicalDevice}',
      '版本号': data.utsname.version,
      '硬件类型': data.utsname.machine,
    };
  }

  static Map<String, dynamic> deviceInfoMap() {
    Map<String, dynamic> deviceInfo = {};
    try {
      if (Platform.isAndroid) {
        deviceInfo = _readAndroidBuildData(instance.androidInfo);
      } else if (Platform.isIOS) {
        deviceInfo = _readIosDeviceInfo(instance.iosInfo);
      }
    } on PlatformException {
      deviceInfo = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    return deviceInfo;
  }
}
