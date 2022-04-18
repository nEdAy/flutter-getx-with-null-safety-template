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
        elevation: 0,
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            '$index',
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: 10,
                    ),
                  ),
                  const Text('共52条记录'),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            '$index',
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: 10,
                    ),
                  ),
                  const Text('共52条记录'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
