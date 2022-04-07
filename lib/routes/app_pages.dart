import 'package:get/get.dart';
import 'package:sunac_flutter/pages/eba/alarm/eba_alarm_view.dart';
import 'package:sunac_flutter/pages/eba/home/eba_home_view.dart';
import 'package:sunac_flutter/pages/eba/report/eba_report_view.dart';

import '../pages/eba/alarm/eba_alarm_binding.dart';
import '../pages/eba/home/eba_home_binding.dart';
import '../pages/eba/report/eba_report_binding.dart';
import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/unknown/unknown_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;
  static const ebaHome = Routes.ebaHome;

  static final routes = [
    ...ebaRoutes,
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];

  static final ebaRoutes = [
    GetPage(
      name: _Paths.ebaHome,
      page: () => const EbaHomeView(),
      binding: EbaHomeBinding(),
    ),
    GetPage(
      name: _Paths.ebaAlarm,
      page: () => const EbaAlarmView(),
      binding: EbaAlarmBinding(),
    ),
    GetPage(
      name: _Paths.ebaReport,
      page: () => const EbaReportView(),
      binding: EbaReportBinding(),
    ),
  ];

  static final unknownRoute = GetPage(
    name: Routes.notFound,
    page: () => const UnknownPage(),
  );
}
