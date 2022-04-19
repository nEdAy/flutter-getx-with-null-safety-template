import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../api/response/report_response/report_response.dart';
import '../../../api/rest_client.dart';

class EbaReportController extends GetxController {
  final isLoading = true.obs;
  final loadingInspectionName = ''.obs;

  final totalDevicesRoom = 0.obs;
  final faultDevicesRoom = 0.obs;
  final totalDevices = 0.obs;
  final faultDevices = 0.obs;

  final List<ReportResponse> reportItems = <ReportResponse>[].obs;

  final RestClient client;

  bool hasError() {
    return faultDevicesRoom.value > 0 || faultDevices.value > 0;
  }

  EbaReportController({required this.client});

  @override
  void onInit() {
    super.onInit();
    _getReport();
  }

  _getReport() {
    loadingInspectionName.value = 'B2/-1层/生活水泵房：EBA设备-1';
    client.getHitokoto("json", "utf-8", noLoading: true).then((value) {
      totalDevicesRoom.value = 52;
      faultDevicesRoom.value = 1;
      totalDevices.value = 214;
      faultDevices.value = 3;
      reportItems.addAll([
        ReportResponse(devicesRoomName: 'D1/-1层/生活水泵房：EBA设备-1', faultDevices: [
          FaultDevice(faultDeviceName: 'EBA设备-1', faultDeviceReason: '故障'),
        ]),
        ReportResponse(devicesRoomName: 'D1/-2层/生活水泵房：EBA设备-8', faultDevices: [
          FaultDevice(faultDeviceName: 'EBA设备-1', faultDeviceReason: '故障'),
          FaultDevice(faultDeviceName: 'EBA设备-2', faultDeviceReason: '停用'),
        ]),
        ReportResponse(devicesRoomName: 'D1/-3层/生活水泵房：EBA设备-7'),
        ReportResponse(devicesRoomName: 'D1/-4层/生活水泵房：EBA设备-6', faultDevices: [
          FaultDevice(faultDeviceName: 'EBA设备-1', faultDeviceReason: '故障'),
          FaultDevice(faultDeviceName: 'EBA设备-2', faultDeviceReason: '停用'),
        ]),
        ReportResponse(devicesRoomName: 'D1/-5层/生活水泵房：EBA设备-5'),
        ReportResponse(devicesRoomName: 'D1/-6层/生活水泵房：EBA设备-4'),
        ReportResponse(devicesRoomName: 'D1/-7层/生活水泵房：EBA设备-3'),
        ReportResponse(devicesRoomName: 'D1/-8层/生活水泵房：EBA设备-2'),
        ReportResponse(devicesRoomName: 'D1/-9层/生活水泵房：EBA设备-1'),
        ReportResponse(devicesRoomName: 'D1/-1层/生活水泵房：EBA设备-1'),
      ]);
      var index = 0;
      Timer.periodic(const Duration(milliseconds: 300), (timer) {
        // 0.3s 回调一次
        if (index < reportItems.length) {
          loadingInspectionName.value =
              reportItems[index].devicesRoomName ?? '';
          index++;
        } else {
          // 取消定时器
          timer.cancel();
          isLoading.value = false;
        }
      });
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
