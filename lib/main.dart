import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sentry/sentry.dart';

import 'api/connectivity_manager.dart';
import 'config/flavor.dart';
import 'global.dart';
import 'routes/app_pages.dart';
import 'widgets/developer_widget.dart';

void main() {
  runZonedGuarded(() async {
    await Sentry.init(
      (options) {
        options
          ..dsn =
              'https://8f96c596bcb0404e80650df83e5cb944@o1149022.ingest.sentry.io/6257332'
          // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
          // We recommend adjusting this value in production.
          ..tracesSampleRate = 1.0;
      },
    );
    // Init your App.
    await Global.init().then(
      (e) => runApp(
        DevicePreview(
          enabled: kDebugMode,
          builder: (context) => const MyApp(),
        ),
      ),
    );
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  }, zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String message) {
    if (kDebugMode) {
      parent.print(zone, message);
    }
  }));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (BuildContext context, Widget? child) {
        return RefreshConfiguration(
          footerTriggerDistance: 50,
          child: GetMaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorSchemeSeed: FlavorConfig.instance.color,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            initialRoute: AppPages.initial,
            initialBinding: BindingsBuilder(() {
              Get.put(ConnectionManagerController(), permanent: true);
            }),
            unknownRoute: AppPages.unknownRoute,
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            getPages: AppPages.routes,
            builder: (context, child) {
              child = botToastBuilder(context, child);
              child = DeveloperWidget(child: child);
              child = DevicePreview.appBuilder(context, child);
              return child;
            },
            debugShowCheckedModeBanner: false,
            navigatorObservers: [BotToastNavigatorObserver()],
            localizationsDelegates: const [
              RefreshLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('zh', 'CH'),
            ],
          ),
        );
      }, // Wrap your app
    );
  }
}
