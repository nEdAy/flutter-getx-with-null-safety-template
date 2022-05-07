import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sunac_flutter/config/flavor.dart';

import '../../../api/response/eba/report_device_status_response/report_device_status_response.dart';
import '../../../api/response/eba/report_eba_device_list_response/report_eba_device_list_response.dart';
import '../../../api/rest_client.dart';
import 'eba_report_download.dart';

class EbaReportController extends GetxController {
  final isLoading = true.obs;
  final loadingInspectionName = ''.obs;

  final totalDevicesRoom = 0.obs;
  final faultDevicesRoom = 0.obs;
  final totalDevices = 0.obs;
  final faultDevices = 0.obs;

  final List<DeviceStatisticsVo> reportItems = <DeviceStatisticsVo>[].obs;

  final RestClient client;

  final CancelToken token = CancelToken();

  bool hasError() {
    return faultDevicesRoom.value > 0 || faultDevices.value > 0;
  }

  launchURL() async {
    String projectId = Get.arguments;
    String url = FlavorConfig.instance.values.baseUrl +
        '/v2/service/device-manage/device-info/check/download?projectId=$projectId';
    await EbaReportDownload().downloadXLSFile(url, token);
  }

  EbaReportController({required this.client});

  @override
  void onInit() {
    super.onInit();
    _getDeviceStatusBySpace();
  }

  @override
  void onClose() {
    super.onClose();
    if (!token.isCancelled) {
      token.cancel();
    }
  }

  _getDeviceStatusBySpace() {
    loadingInspectionName.value = '巡检中...';
    final String projectId = Get.arguments;
    final request = {
      'projectId': projectId,
      'deviceTypeId': '3681568654222299015',
    };
    client.getDeviceStatusBySpace(request).then((value) {
      if (value.status == 200) {
        final reportDeviceStatus = value.data;
        totalDevicesRoom.value = reportDeviceStatus?.deviceSpaceAllNum ?? 0;
        faultDevicesRoom.value = reportDeviceStatus?.deviceSpaceBugNum ?? 0;
        totalDevices.value = reportDeviceStatus?.deviceAllNum ?? 0;
        faultDevices.value = reportDeviceStatus?.deviceBugNum ?? 0;
        final deviceStatisticsVoList =
            reportDeviceStatus?.deviceStatisticsVoList;
        if (deviceStatisticsVoList != null &&
            deviceStatisticsVoList.isNotEmpty) {
          reportItems.addAll(deviceStatisticsVoList);
          _showLoadingAnimation();
        } else {
          isLoading.value = false;
        }
      }
    });
  }

  _showLoadingAnimation() {
    var index = 0;
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      // 0.3s 回调一次
      if (index < reportItems.length) {
        loadingInspectionName.value = reportItems[index].fullSpaceName ?? '';
        index++;
      } else {
        // 取消定时器
        timer.cancel();
        isLoading.value = false;
      }
    });
  }

  getReportRbaDeviceList(String? spaceId, RxBool isUnfold,
      RxList<EbaDevice> abnormalEbaDeviceList, RxBool isLoading) {
    if (isLoading.value == true) {
      return;
    }
    if (abnormalEbaDeviceList.isNotEmpty) {
      isUnfold.value = !isUnfold.value;
    } else {
      final String projectId = Get.arguments;
      final request = {
        'projectId': projectId,
        'deviceTypeId': '3681568654222299015',
        "spaceId": spaceId ?? ''
      };
      isLoading.value = true;
      client.getEbaListBySpace(request).then((value) {
        isLoading.value = false;
        if (value.status == 200) {
          final ebaDeviceList = value.data?.getBugAndStopEbaDeviceList();
          if (ebaDeviceList != null && ebaDeviceList.isNotEmpty) {
            abnormalEbaDeviceList.addAll(ebaDeviceList);
            isUnfold.value = !isUnfold.value;
          }
        }
      }).catchError((_) {
        isLoading.value = false;
      });
    }
  }
}
