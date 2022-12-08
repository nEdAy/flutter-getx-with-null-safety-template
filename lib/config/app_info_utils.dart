import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoConfig {
  factory PackageInfoConfig({
    required PackageInfo packageInfo,
  }) {
    _instance = PackageInfoConfig._internal(packageInfo);
    return _instance;
  }

  PackageInfoConfig._internal(this.packageInfo);

  final PackageInfo packageInfo;

  static late PackageInfoConfig _instance;

  static PackageInfoConfig get instance {
    return _instance;
  }

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
