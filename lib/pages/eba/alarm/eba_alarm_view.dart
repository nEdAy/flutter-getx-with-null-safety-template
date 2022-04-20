import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/round_underline_tab_indicator.dart';
import 'eba_alarm_controller.dart';

class EbaAlarmView extends GetView<EbaAlarmController> {
  const EbaAlarmView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('告警',
            style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 16,
        ),
        bottom: TabBar(
          controller: controller.tabController,
          indicator: const RoundUnderlineTabIndicator(
              width: 20,
              borderSide: BorderSide(
                width: 3,
                color: Color(0xFFD97F00),
              )),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          labelColor: Colors.black,
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          unselectedLabelColor: const Color(0xFF434343),
          unselectedLabelStyle: const TextStyle(fontSize: 16),
          tabs: controller.tabs.map((value) {
            return Tab(text: value, height: 46);
          }).toList(),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: controller.tabController,
          children: [
            _buildEbaAlarmItemView(true),
            _buildEbaAlarmItemView(false)
          ],
        ),
      ),
    );
  }

  _buildEbaAlarmItemView(bool isMajor) {
    return Obx(
      () => Column(
        children: (isMajor
                ? controller.majorAlarmItems.isEmpty
                : controller.minorAlarmItems.isEmpty)
            ? <Widget>[
                const SizedBox(height: 120),
                const Text(
                  '暂无',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF767676), fontSize: 16),
                )
              ]
            : <Widget>[
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (isMajor
                                        ? controller.majorAlarmItems[index]
                                        : controller.minorAlarmItems[index]) +
                                    'EBA监控设备-42：A8天台液低水位告警',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (isMajor
                                            ? controller.majorAlarmItems[index]
                                            : controller
                                                .minorAlarmItems[index]) +
                                        '液位值<0.8',
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xFF434343)),
                                  ),
                                  Text(
                                    (isMajor
                                            ? controller.majorAlarmItems[index]
                                            : controller
                                                .minorAlarmItems[index]) +
                                        '今天 16:13:25',
                                    style: const TextStyle(
                                        fontSize: 14, color: Color(0xFFAAAAAA)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                          height: 1, indent: 20, endIndent: 20);
                    },
                    itemCount: isMajor
                        ? controller.majorAlarmItems.length
                        : controller.minorAlarmItems.length,
                  ),
                ),
              ],
      ),
    );
  }
}