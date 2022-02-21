import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ErrorUtil {
  static const sunacFlutterDSN =
      'https://5ebe5dae0f3546b9be9dc0c4dc8c6590@o1149022.ingest.sentry.io/6220719';

  static String getSentryDSN() {
    return sunacFlutterDSN;
  }

  static void handleError(dynamic exception, StackTrace stackTrace) {
    _filterAndUploadException(exception, stackTrace);
  }

  static void _filterAndUploadException(dynamic error, StackTrace stackTrace) {
    if (_filterException(error, stackTrace)) {
      Logger().e(error, error, stackTrace);
      try {
        Sentry.captureException(error, stackTrace: stackTrace);
        Logger().e('Error sent to Sentry: $error');
      } catch (e) {
        Logger().e('Sending report to Sentry failed: $e');
        Logger().e('Original error: $error');
      }
    }
  }

  static bool _filterException(dynamic error, StackTrace stackTrace) {
    if (error == null) {
      return false;
    } else {
      error ??= Error();
      if (error is Error) {
        stackTrace = error.stackTrace!;
      } else {
        stackTrace = StackTrace.empty;
      }
      return true;
    }
  }
}
