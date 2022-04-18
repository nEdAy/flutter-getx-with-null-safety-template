import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      ),
      body: SafeArea(
        child: Center(
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
      ),
    );
  }
}
