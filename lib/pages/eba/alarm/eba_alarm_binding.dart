import 'package:get/get.dart';

import '../../../api/http_manager.dart';
import 'eba_alarm_controller.dart';

class EbaAlarmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EbaAlarmController>(
      () => EbaAlarmController(client: HttpManager().client),
    );
  }
}
