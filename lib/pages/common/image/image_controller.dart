import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';

class ImageController extends GetxController {
  final pageIndex = 0.obs;

  late final ExtendedPageController pageController;

  late final List<String>? titles;
  late final List<String>? urls;
  late final Map<String, String>? headers;

  late List<File?>? files;
  late final bool? enableMemoryCache;
  late final bool? clearMemoryCacheWhenDispose;

  @override
  void onInit() {
    super.onInit();
    final initialPageIndex = Get.arguments['pageIndex'] ?? 0;
    pageController = ExtendedPageController(
      initialPage: initialPageIndex,
      pageSpacing: 50,
    );
    pageIndex.value = initialPageIndex;

    titles = Get.arguments['titles'];

    urls = Get.arguments['urls'];
    headers = Get.arguments['headers'];

    files = Get.arguments['files'];
    enableMemoryCache = Get.arguments['enableMemoryCache'];
    clearMemoryCacheWhenDispose = Get.arguments['clearMemoryCacheWhenDispose'];
  }
}
