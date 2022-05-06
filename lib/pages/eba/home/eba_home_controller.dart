import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunac_flutter/channel/get_user_info.dart';

import '../../../api/response/eba/project_list_response/project_list_response.dart';
import '../../../api/rest_client.dart';

class EbaHomeController extends GetxController {
  final totalDevices = 0.obs;
  final faultDevices = 0.obs;
  final disableDevices = 0.obs;

  final majorAlarm = 0.obs;
  final minorAlarm = 0.obs;

  final isDropDownActive = false.obs;
  final currentProjectName = "".obs;
  final currentProjectId = "".obs;
  final List<Project> filteredProjectItems = <Project>[].obs;
  final List<Project> allProjectItems = <Project>[].obs;
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

  onProjectSearchItemClick(Project project) {
    currentProjectId.value = project.id ?? '';
    currentProjectName.value = project.name ?? '';
    switchDropDownToInactive();
    var projectId = project.id;
    if (projectId != null && projectId.isNotEmpty) {
      _getProjectData(projectId);
    }
  }

  void onSearchInputChanged(String value) {
    projectSearchKeyword.value = value;
    filteredProjectItems.clear();
    if (value.isBlank ?? true) {
      filteredProjectItems.addAll(allProjectItems);
    } else {
      var newFilteredProjectItems = <Project>[];
      for (var element in allProjectItems) {
        if (element.name?.contains(value) ?? false) {
          newFilteredProjectItems.add(element);
        }
      }
      filteredProjectItems.addAll(newFilteredProjectItems);
    }
  }

  _getProjectNameList() async {
    final userInfo = await GetUserInfo.getUserInfo();
    client.getProjectList(userInfo?['memberId']).then((value) {
      if (value.status == 200) {
        var projectList = value.data?.projectList;
        if (projectList != null && projectList.isNotEmpty) {
          allProjectItems.addAll(projectList);
          var currentProject = allProjectItems.first;
          currentProjectName.value = currentProject.name ?? '';
          currentProjectId.value = currentProject.id ?? '';
          if (currentProjectId.value.isNotEmpty) {
            _getProjectData(currentProjectId.value);
          }
          filteredProjectItems.addAll(allProjectItems);
        }
      }
    });
  }

  _getProjectData(String projectId) {
    _getDeviceStatus(projectId);
    _getAlarmLogs(projectId);
  }

  void _getDeviceStatus(String projectId) {
    client.getDeviceStatus(projectId).then((value) {
      if (value.status == 200) {
        var deviceStatus = value.data;
        if (deviceStatus != null) {
          totalDevices.value = (deviceStatus.onlineCount ?? 0) +
              (deviceStatus.bugCount ?? 0) +
              (deviceStatus.stopCount ?? 0);
          faultDevices.value = deviceStatus.bugCount ?? 0;
          disableDevices.value = deviceStatus.stopCount ?? 0;
        }
      }
    });
  }

  void _getAlarmLogs(String projectId) {
    client.getAlarmLogs(projectId).then((value) {
      if (value.status == 200) {
        var alarmLogs = value.data;
        if (alarmLogs != null) {
          majorAlarm.value = alarmLogs.serious ?? 0;
          minorAlarm.value = alarmLogs.commonly ?? 0;
        }
      }
    });
  }
}
