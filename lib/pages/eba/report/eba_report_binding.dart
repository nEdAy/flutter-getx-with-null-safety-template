import 'package:get/get.dart';

import '../../../api/http_manager.dart';
import 'eba_report_controller.dart';

class EbaReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EbaReportController>(
      () => EbaReportController(client: HttpManager().client),
    );
  }
}
