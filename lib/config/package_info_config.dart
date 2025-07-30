import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoConfig {
  final PackageInfo packageInfo;

  static late final PackageInfoConfig _instance;

  PackageInfoConfig._internal(this.packageInfo);

  factory PackageInfoConfig(PackageInfo packageInfo) =>
      PackageInfoConfig._internal(packageInfo);

  static String getBuildNumber() => _instance.packageInfo.buildNumber;

  static String getVersion() => _instance.packageInfo.version;

  static String getAppName() => _instance.packageInfo.appName;

  static String getBuildSignature() => _instance.packageInfo.buildSignature;

  static String getPackageName() => _instance.packageInfo.packageName;

  static Map<String, String> packageInfoMap() {
    return {
      'BuildNumber': getBuildNumber(),
      'Version': getVersion(),
      'AppName': getAppName(),
      'BuildSignature': getBuildSignature(),
      'PackageName': getPackageName(),
    };
  }
}
