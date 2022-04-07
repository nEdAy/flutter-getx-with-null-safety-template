import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import 'eba_home_controller.dart';

class EbaHomeView extends GetView<EbaHomeController> {
  const EbaHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EBA - 首页'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('设备总览'),
              const Text('告警总览'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      child: const Text('告警'),
                      onPressed: () => Get.toNamed(Routes.ebaAlarm)),
                  TextButton(
                      child: const Text('一键巡检'),
                      onPressed: () => Get.toNamed(Routes.ebaReport)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
