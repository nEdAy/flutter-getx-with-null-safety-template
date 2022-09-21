import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';

class ImageController extends GetxController {
  final ExtendedPageController pageController = ExtendedPageController(
    initialPage: 0,
    pageSpacing: 50,
  );

  late final List<String>? titles;
  late final List<String>? urls;
  late final Map<String, String>? headers;

  late List<File?>? files;
  late final bool? enableMemoryCache;
  late final bool? clearMemoryCacheWhenDispose;

  final pageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    titles = Get.arguments['titles'];

    urls = Get.arguments['urls'];
    headers = Get.arguments['headers'];
    pageIndex.value = Get.arguments['pageIndex']?? 0;

    files = Get.arguments['files'];
    enableMemoryCache = Get.arguments['enableMemoryCache'];
    clearMemoryCacheWhenDispose = Get.arguments['clearMemoryCacheWhenDispose'];
  }
}
