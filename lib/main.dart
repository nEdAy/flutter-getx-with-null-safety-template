import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_settings.dart';

import 'env/env_banner.dart';
import 'global.dart';
import 'routes/app_pages.dart';
import 'utils/error_utils.dart';
import 'widgets/developer_widget.dart';

void main() {
  runZonedGuarded(
    () async {
      await SentryFlutter.init((options) {
        options
          ..dsn = ErrorUtils.getSentryDSN()
          ..addIntegration(LoggingIntegration())
          ..tracesSampleRate =
              1.0 // needed for Dio `networkTracing` feature
          ..debug = kDebugMode
          ..sendDefaultPii = true
          ..beforeSend = ErrorUtils.beforeSend;
      });
      await Global.init().then(
        (_) => runApp(
          DefaultAssetBundle(
            bundle: SentryAssetBundle(),
            child: DevicePreview(
              enabled: kDebugMode,
              builder: (context) => ProviderScope(
                observers: [
                  TalkerRiverpodObserver(
                    talker: talker,
                    settings: TalkerRiverpodLoggerSettings(
                      enabled: kDebugMode,
                      printProviderFailed: true,
                    ),
                  ),
                ],
                child: const MyApp(),
              ),
            ),
          ),
        ),
      );
    },
    (exception, stackTrace) async {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    },
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String message) {
        if (kDebugMode) {
          parent.print(zone, message);
        }
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return ScreenUtilInit(
      designSize: defaultDesignSize,
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          routerConfig: router,
          title: appName,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          darkTheme: ThemeData.dark(useMaterial3: true),
          locale: DevicePreview.locale(context),
          builder: (context, child) {
            child = botToastBuilder(context, child);
            child = DeveloperWidget(child: child);
            child = EnvBanner(child: child);
            child = DevicePreview.appBuilder(context, child);
            return child;
          },
          debugShowCheckedModeBanner: kDebugMode,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('zh', 'CH')],
        );
      }, // Wrap your app
    );
  }
}
