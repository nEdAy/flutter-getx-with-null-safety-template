import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'eba_report_controller.dart';

class EbaReportView extends GetView<EbaReportController> {
  const EbaReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: 50),
            const SizedBox(
              child: CircularProgressIndicator(
                color: Color(0xFFFF9F08),
                backgroundColor: Color(0xFFF0F0F0),
                strokeWidth: 10,
                semanticsLabel: 'Linear progress indicator',
              ),
              height: 80.0,
              width: 80.0,
            ),
            Container(height: 30),
            const Text('自动巡检中',
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
            Container(height: 12),
            const Text('B2/-1层/生活水泵房：EBA设备-1',
                style: TextStyle(color: Color(0xFF434343), fontSize: 16)),
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
            ElevatedButton(
              onPressed: _launchURL,
              child: const Text('一键巡检表'),
            ),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  void _launchURL() async {
    const String _url = 'https://flutter.dev';
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}
