import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../api/response/eba/alarm_logs_list_response/alarm_logs_list_response.dart';
import '../../../api/rest_client.dart';

class EbaAlarmController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<String> tabs = ['严重告警', '一般告警'];
  late TabController tabController;

  final RestClient client;

  final Map<bool, List<AlarmLogs>> alarmItemsMap = {
    false: <AlarmLogs>[].obs,
    true: <AlarmLogs>[].obs
  };

  final Map<bool, RefreshController> refreshControllerMap = {
    false: RefreshController(initialRefresh: false),
    true: RefreshController(initialRefresh: false)
  };

  final _initPageSize = 20;
  final Map<bool, int> _currentPageMap = {false: 0, true: 0};

  EbaAlarmController({required this.client});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: tabs.length);
    onRefresh(true);
    onRefresh(false);
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }

  onRefresh(bool isMajor) async {
    _currentPageMap[isMajor] = 0;
    await _getAlarmLogsList(0, isMajor, isRefresh: true);
  }

  onLoading(bool isMajor) async {
    _currentPageMap[isMajor] = (_currentPageMap[isMajor] ?? 0) + 1;
    await _getAlarmLogsList(_currentPageMap[isMajor] ?? 0, isMajor);
  }

  Future _getAlarmLogsList(int offset, bool isMajor,
      {bool isRefresh = false}) async {
    final String projectId = Get.arguments;
    final request = {
      'offset': offset,
      'limit': _initPageSize,
      'projectId': projectId,
      'dtId': '3681568654222299015',
      'alarmLevel': isMajor ? 1 : 3,
    };
    final alarmItems = alarmItemsMap[isMajor];
    final refreshController = refreshControllerMap[isMajor];
    await client
        .getAlarmLogsList(request)
        .then((value) {
      if (value.status == 200) {
        final alarmLogsList = value.data?.alarmLogsList;
        if (alarmLogsList != null && alarmLogsList.isNotEmpty) {
          if (isRefresh) {
            alarmItems?.clear();
            alarmItems?.addAll(alarmLogsList);
            refreshController?.refreshCompleted();
          } else {
            alarmItems?.addAll(alarmLogsList);
            refreshController?.loadComplete();
          }
        } else {
          if (isRefresh) {
            refreshController?.refreshToIdle();
          } else {
            refreshController?.loadNoData();
          }
        }
      } else {
        if (isRefresh) {
          refreshController?.refreshFailed();
        } else {
          refreshController?.loadFailed();
        }
      }
    }).catchError((error) {
      if (isRefresh) {
        refreshController?.refreshFailed();
      } else {
        refreshController?.loadFailed();
      }
    });
  }
}
