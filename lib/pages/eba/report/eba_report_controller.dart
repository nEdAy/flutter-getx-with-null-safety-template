import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../api/rest_client.dart';

class EbaReportController extends GetxController {
  final isLoading = true.obs;
  final loadingInspectionName = ''.obs;

  final totalDevicesRoom = 0.obs;
  final faultDevicesRoom = 0.obs;
  final totalDevices = 0.obs;
  final faultDevices = 0.obs;

  final List<String> reportItems = <String>[].obs;

  final RestClient client;

  bool hasError() {
    return faultDevicesRoom.value > 0 || faultDevices.value > 0;
  }

  EbaReportController({required this.client});

  @override
  void onInit() {
    super.onInit();
    _getHitokoto();
  }

  onRefresh() {
    _getHitokoto();
  }

  _getHitokoto() {
    loadingInspectionName.value = 'B2/-1层/生活水泵房：EBA设备-1';
    client.getHitokoto("json", "utf-8", noLoading: true).then((value) {
      Timer(const Duration(seconds: 5), () {
        //callback function
        isLoading.value = false;
      });
      totalDevicesRoom.value = 52;
      faultDevicesRoom.value = 1;
      totalDevices.value = 214;
      faultDevices.value = 3;
      reportItems.clear();
      reportItems.addAll([
        'D1/-1层/生活水泵房',
        'D1/-1层/生活水泵房',
        'D1/-1层/生活水泵房',
        'D1/-1层/生活水泵房',
        'D1/-1层/生活水泵房',
        'D1/-1层/生活水泵房',
        'D1/-1层/生活水泵房',
        'D1/-1层/生活水泵房',
        'D1/-1层/生活水泵房'
      ]);
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
