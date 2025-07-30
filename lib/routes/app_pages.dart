import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../env/env_switcher.dart';
import '../global.dart';
import '../pages/common/login/login_view.dart';
import '../pages/home/home.dart';
import '../pages/unknown/unknown_view.dart';
import '../store/store_manager.dart';

part 'app_paths.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  navigatorKey: navigatorGlobalKey,
  initialLocation: _initial,
  observers: [
    SentryNavigatorObserver(),
    TalkerRouteObserver(talker),
    BotToastNavigatorObserver(),
  ],
  routes: <RouteBase>[
    GoRoute(
      path: _initial,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeView();
      },
      routes: _routes,
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final isAuthenticated =
        StoreManager.instance.pref.getString(kAccessToken)?.isNotEmpty ==
        true; // your logic to check if user is authenticated
    if (!EnvSwitcher.isDevelopment() &&
        kDebugMode &&
        !isAuthenticated &&
        _requiredAuthenticatedPaths.contains(state.matchedLocation)) {
      return Paths.login;
    } else {
      return null; // return "null" to display the intended route without redirecting
    }
  },
  errorBuilder: (context, state) => UnknownPage(state.error),
);

final GlobalKey<NavigatorState> navigatorGlobalKey = GlobalKey<NavigatorState>();

const _initial = Paths.home;

final List<RouteBase> _routes = [..._commonRoutes];

final _commonRoutes = [
  GoRoute(
    path: Paths.login,
    builder: (BuildContext context, GoRouterState state) {
      return const LoginView();
    },
  ),
  // GoRoute(
  //   path: Paths.image,
  //   builder: (BuildContext context, GoRouterState state) {
  //     return const ImageView();
  //   },
  // ),
];

final List<String> _requiredAuthenticatedPaths = [];
