import 'package:get/get.dart';

import '../pages/common/image/image_binding.dart';
import '../pages/common/image/image_view.dart';
import '../pages/common/login/login_binding.dart';
import '../pages/common/login/login_view.dart';
import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/unknown/unknown_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    ...commonRoutes,
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];

  static final commonRoutes = [
    GetPage(
      name: _Paths.image,
      page: () => const ImageView(),
      binding: ImageBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
  ];

  static final unknownRoute = GetPage(
    name: Routes.notFound,
    page: () => const UnknownPage(),
  );
}
