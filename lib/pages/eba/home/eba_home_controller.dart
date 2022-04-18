import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../api/rest_client.dart';

class EbaHomeController extends GetxController {
  final totalDevices = 0.obs;
  final faultDevices = 0.obs;
  final disableDevices = 0.obs;

  final majorAlarm = 0.obs;
  final minorAlarm = 0.obs;

  final RestClient client;

  EbaHomeController({required this.client});

  @override
  void onInit() {
    super.onInit();
    _getHitokoto();
  }

  onRefresh() {
    _getHitokoto();
  }

  _getHitokoto() {
    client.getHitokoto("json", "utf-8").then((value) {
      totalDevices.value = 98;
      faultDevices.value = 1;
      disableDevices.value = 3;
      majorAlarm.value = 98;
      minorAlarm.value = 1;
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
