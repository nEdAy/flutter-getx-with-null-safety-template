import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../api/http_manager.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  final hitokoto = "".obs;
  final from = "".obs;

  void increment() => count.value++;

  @override
  void onInit() {
    super.onInit();
    _getHitokoto();
  }

  onRefresh() {
    _getHitokoto();
  }

  _getHitokoto() {
    HttpManager().client.getHitokoto("json", "utf-8").then((value) {
      hitokoto.value = value.hitokoto ?? "";
      from.value = value.from ?? "";
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          Logger().e("Got error : ${res?.statusCode} -> ${res?.statusMessage}");
          break;
        default:
          break;
      }
    });
  }
}
