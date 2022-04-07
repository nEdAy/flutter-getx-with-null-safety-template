import 'package:get/get.dart';

import '../../../api/http_manager.dart';
import 'eba_home_controller.dart';

class EbaHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EbaHomeController>(
      () => EbaHomeController(client: HttpManager().client),
    );
  }
}
