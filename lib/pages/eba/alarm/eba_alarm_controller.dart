import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/rest_client.dart';

class EbaAlarmController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<String> tabs = ['严重告警', '一般告警'];
  late TabController tabController;

  final RestClient client;

  final List<String> majorAlarmItems = [''].obs;
  final List<String> minorAlarmItems = [''].obs;

  EbaAlarmController({required this.client});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: tabs.length);
    //_getHitokoto();
  }

  onRefresh() {
    // _getHitokoto();
  }

  _getAlarmLogsList(int offset, int limit, String projectId, int alarmLevel) {
    final request = {
      'offset': offset,
      'limit': limit,
      'projectId': projectId,
      'dtId': '3681568654222299015',
      'alarmLevel': alarmLevel,
    };
    client.getAlarmLogsList(request, "utf-8").then((value) {
      majorAlarmItems.addAll(['', '', '', '', '']);
      minorAlarmItems.addAll(['', '', '']);
    });
  }
}
