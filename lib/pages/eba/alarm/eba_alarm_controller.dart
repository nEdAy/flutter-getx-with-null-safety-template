import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../api/rest_client.dart';

class EbaAlarmController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<String> tabs = ['严重告警','一般告警'];
  late TabController tabController;

  final RestClient client;

  final List<String> majorAlarmItems = [''].obs;
  final List<String> minorAlarmItems = [''].obs;

  EbaAlarmController({required this.client});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: tabs.length);
    _getHitokoto();
  }

  onRefresh() {
    _getHitokoto();
  }

  _getHitokoto() {
    client.getHitokoto("json", "utf-8").then((value) {
      majorAlarmItems.addAll(['','','','','']);
      minorAlarmItems.addAll(['','','']);
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
