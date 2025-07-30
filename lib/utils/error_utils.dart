import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/package_info_config.dart';
import '../config/device_info_config.dart';

class ErrorUtils {
  static const _debugSentryDSN =
      'http://9e1cba0c5bbe4db492dbbd543589943c@172.17.44.99:9000/3';
  static const _releaseSentryDSN =
      'http://80793351cec347488f5bcc3ef3e57082@172.17.44.99:9000/5';

  static String getSentryDSN() {
    return !kDebugMode ? _releaseSentryDSN : _debugSentryDSN;
  }

  static void configureUser(String username, String token) {
    Sentry.configureScope((Scope scope) {
      scope.setUser(SentryUser(username: username, data: {'Token': token}));
    });
  }

  static void configureTag() {
    Sentry.configureScope((Scope scope) {
      scope
        ..setTag('Version', PackageInfoConfig.getVersion())
        ..setTag('BuildNumber', PackageInfoConfig.getBuildNumber())
        ..setTag('DeviceModel', DeviceInfoConfig.deviceModel())
        ..setTag('DeviceManufacturer', DeviceInfoConfig.deviceManufacturer())
        ..setTag('DeviceSystemVersion', DeviceInfoConfig.deviceSystemVersion());
      scope
        ..setContexts('PackageInfo', PackageInfoConfig.packageInfoMap())
        ..setContexts('DeviceInfo', DeviceInfoConfig.deviceInfoMap());
    });
  }

  static final ignoreErrorType = [];

  static final ignoreErrorValue = [
    'An async write transaction is already in progress in this isolate',
    "The error handler of Future.catchError must return a value of the future's type",
    'Connecting timed out',
    'Connection reset by peer',
    'Connection closed before full header was received',
    'Broken pipe',
    'Failed host lookup',
    'Software caused connection abort',
    'Connection closed while receiving data',
  ];

  static FutureOr<SentryEvent?> beforeSend(
    SentryEvent event,
    dynamic hint,
  ) async {
    final exceptions = event.exceptions;
    if (exceptions != null) {
      for (var exception in exceptions) {
        for (var type in ignoreErrorType) {
          if (exception.type == type) {
            // drop it completely (by returning null)
            return null;
          }
        }
        for (var value in ignoreErrorValue) {
          if (exception.value?.contains(value) == true) {
            // drop it completely (by returning null)
            return null;
          }
        }
      }
    }
    return event;
  }
}
