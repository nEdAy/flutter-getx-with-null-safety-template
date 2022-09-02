import 'package:get/get.dart';

import 'image_controller.dart';

class ImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageController>(
      () => ImageController(),
    );
  }
}
