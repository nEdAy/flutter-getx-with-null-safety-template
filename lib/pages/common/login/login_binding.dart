import 'package:get/get.dart';

import '../../../api/http_manager.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
          () => LoginController(client: HttpManager().client),
    );
  }
}
