import 'dart:async';

import 'package:sentry/sentry.dart';

import '../config/app_info_utils.dart';
import '../config/device_info.dart';
import '../config/user_info.dart';

const sentryDSN =
    'https://8f96c596bcb0404e80650df83e5cb944@o1149022.ingest.sentry.io/6257332';

class ErrorUtils {
  static configureUser() {
    Sentry.configureScope((Scope scope) {
      scope.setUser(SentryUser(
        username: UserInfoConfig.getOaAccount(),
        name: UserInfoConfig.getUserName(),
        data: {
          'LoginPhone': UserInfoConfig.getLoginPhone(),
          'MemberId': UserInfoConfig.getMemberId(),
          'Token': UserInfoConfig.getToken(),
        },
      ));
    });
  }

  static configureTag() {
    Sentry.configureScope((Scope scope) {
      scope
        ..setTag('Version', PackageInfoConfig.getVersion())
        ..setTag('BuildNumber', PackageInfoConfig.getBuildNumber())
        ..setTag('DeviceModel', DeviceInfoConfig.deviceModel())
        ..setTag('DeviceManufacturer', DeviceInfoConfig.deviceManufacturer())
        ..setTag('DeviceSystemVersion', DeviceInfoConfig.deviceSystemVersion());
      scope
        ..setExtra('PackageInfo', PackageInfoConfig.packageInfoMap())
        ..setExtra('DeviceInfo', DeviceInfoConfig.deviceInfoMap());
    });
  }

  FutureOr<SentryEvent?> beforeSend(SentryEvent preparedEvent,
      {dynamic hint}) async {
    return preparedEvent;
  }
}
