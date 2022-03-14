import 'package:get/get.dart';

import '../../api/http_manager.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(client: HttpManager().client),
    );
  }
}
