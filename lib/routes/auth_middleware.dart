import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

import '../config/flavor.dart';
import '../config/user_info.dart';

class EnsureAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final isLogin = UserInfoConfig.instance.userInfo.token.isNotEmpty;
    if (FlavorConfig.isUAT() && kDebugMode && !isLogin) {
      // return RouteSettings(name: Routes.login, arguments: route);
    } else {
      return null;
    }
  }
}
