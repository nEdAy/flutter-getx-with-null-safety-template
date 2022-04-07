import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'eba_report_controller.dart';

class EbaReportView extends GetView<EbaReportController> {
  const EbaReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EBA - 一键巡检'),
        centerTitle: true,
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
              const Text('查看巡检报表'),
              const Text('一键巡检表'),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
