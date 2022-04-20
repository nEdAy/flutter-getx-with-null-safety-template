import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../api/rest_client.dart';

class EbaHomeController extends GetxController {
  final totalDevices = 0.obs;
  final faultDevices = 0.obs;
  final disableDevices = 0.obs;

  final majorAlarm = 0.obs;
  final minorAlarm = 0.obs;

  final isDropDownActive = false.obs;
  final currentProjectName = "".obs;
  final List<String> filteredProjectItems = <String>[].obs;
  final List<String> allProjectItems = <String>[];
  final TextEditingController projectSearchController = TextEditingController();

  final FocusNode focusNode = FocusNode();
  final projectSearchHintText = "搜索项目名称".obs;
  final projectSearchKeyword = "".obs;

  final RestClient client;

  EbaHomeController({required this.client});

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        projectSearchHintText.value = '搜索项目名称';
      } else {
        projectSearchHintText.value = ' 搜索主机名称、编号、位置';
      }
    });
    _getProjectNameList();
  }

  onDropDownTap() {
    if (isDropDownActive.value) {
      switchDropDownToInactive();
    } else {
      isDropDownActive.value = true;
    }
  }

  switchDropDownToInactive() {
    isDropDownActive.value = false;
    projectSearchController.clear();
    onSearchInputChanged('');
  }

  onProjectSearchItemClick(String name) {
    currentProjectName.value = name;
    switchDropDownToInactive();
    _getProjectData(name);
  }

  void onSearchInputChanged(String value) {
    projectSearchKeyword.value = value;
    filteredProjectItems.clear();
    if (value.isBlank ?? true) {
      filteredProjectItems.addAll(allProjectItems);
    } else {
      var newFilteredProjectItems = <String>[];
      for (var element in allProjectItems) {
        if (element.contains(value)) {
          newFilteredProjectItems.add(element);
        }
      }
      filteredProjectItems.addAll(newFilteredProjectItems);
    }
  }

  _getProjectNameList() {
    client.getHitokoto("json", "utf-8").then((value) {
      allProjectItems.addAll([
        '天津融创中心',
        '天津融创中心2',
        '天津融创中心3天津融创中心3天津融创中心3天津融创中心3天津融创中心3',
        '天津臻园',
        '天津臻园2',
        '天津东岸明郡',
        '天津东岸明郡2',
        '天津半湾半岛',
        '天津半湾半岛2',
      ]);
      currentProjectName.value = allProjectItems.first;
      _getProjectData(currentProjectName.value);
      filteredProjectItems.addAll(allProjectItems);
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

  _getProjectData(String name) {
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
