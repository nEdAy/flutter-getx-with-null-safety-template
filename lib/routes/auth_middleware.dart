import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

import '../config/flavor.dart';
import '../config/user_info.dart';
import 'app_pages.dart';

class EnsureAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final isLogin = UserInfoConfig.instance.userInfo.token?.isNotEmpty == true;
    if (FlavorConfig.isUAT() && kDebugMode && !isLogin) {
      return RouteSettings(
        name: Routes.login,
        arguments: {
          'route': route,
        },
      );
    } else {
      return null;
    }
  }
}
