import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../gen/assets.gen.dart';
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
          children: <Widget>[
            Obx(
              () => Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildHeaderView(context);
                    }
                    index -= 1;
                    var reportItem = controller.reportItems[index];
                    var isUnfold = false.obs;
                    return Obx(
                      () => Visibility(
                        visible: !controller.isLoading.value,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  reportItem.faultDevices?.isNotEmpty ?? false
                                      ? Assets.images.iconReportItemHasError
                                          .image(width: 16, height: 16)
                                      : Assets.images.iconReportItemNoError
                                          .image(width: 16, height: 16),
                                  const SizedBox(width: 10),
                                  Text(
                                    reportItem.devicesRoomName ?? '',
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: reportItem.faultDevices?.isNotEmpty ??
                                    false,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 26),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Text(
                                            '异常',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF434343),
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${reportItem.faultDevices?.length ?? 0}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFFD97F00),
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(width: 4),
                                          Obx(() {
                                            return GestureDetector(
                                              child: isUnfold.value
                                                  ? const Icon(
                                                      Icons.keyboard_arrow_up,
                                                      size: 16)
                                                  : const Icon(
                                                      Icons.keyboard_arrow_down,
                                                      size: 16),
                                              onTap: () => isUnfold.value =
                                                  !isUnfold.value,
                                            );
                                          }),
                                        ],
                                      ),
                                      Visibility(
                                        visible: isUnfold.value,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 1,
                                              width: context.width,
                                              color: const Color(0xFFF0F0F0),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                            ),
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, subIndex) {
                                                var faultDevices = reportItem
                                                    .faultDevices![subIndex];
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      faultDevices
                                                              .faultDeviceName ??
                                                          '',
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Color(
                                                              0xFF434343)),
                                                    ),
                                                    Text(
                                                      faultDevices
                                                              .faultDeviceReason ??
                                                          '',
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xFFD91D00)),
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return const SizedBox(
                                                    height: 12);
                                              },
                                              itemCount: reportItem
                                                      .faultDevices?.length ??
                                                  0,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                  itemCount: controller.reportItems.isEmpty
                      ? 1
                      : controller.reportItems.length + 1,
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: !controller.isLoading.value,
                child: Container(
                  width: context.width,
                  height: 82,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  color: Colors.white,
                  child: ElevatedButton(
                    onPressed: _launchURL,
                    child: const Text(
                      '查看巡检报表',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFFF9F08)),
                  ),
                ),
              ),
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

  Column _buildHeaderView(BuildContext context) {
    return Column(children: [
      SizedBox(height: 50, width: context.width),
      Obx(
        () => controller.isLoading.value
            ? Container(
                child: const CircularProgressIndicator(
                  color: Color(0xFFFF9F08),
                  backgroundColor: Color(0xFFF0F0F0),
                  strokeWidth: 10,
                  semanticsLabel: 'Linear progress indicator',
                ),
                height: 100.0,
                width: 100.0,
                padding: const EdgeInsets.all(10.0),
              )
            : (controller.hasError()
                ? Assets.images.iconReportHasError
                    .image(width: 100, height: 100)
                : Assets.images.iconReportNoError
                    .image(width: 100, height: 100)),
      ),
      const SizedBox(height: 20),
      Obx(
        () => Text(
          controller.isLoading.value
              ? '自动巡检中'
              : (controller.hasError() ? '巡检完成，请关注异常' : '巡检完成，无异常'),
          style: const TextStyle(
              color: Color(0xFF000000),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      const SizedBox(height: 12),
      Obx(
        () => controller.isLoading.value
            ? Text('${controller.loadingInspectionName}',
                style: const TextStyle(color: Color(0xFF434343), fontSize: 16))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 153,
                    height: 64,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('设备房',
                            style: TextStyle(color: Color(0xFF767676))),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('总计',
                                style: TextStyle(color: Color(0xFF434343))),
                            const SizedBox(width: 4),
                            Text('${controller.totalDevicesRoom}',
                                style:
                                    const TextStyle(color: Color(0xFF434343))),
                            const SizedBox(width: 16),
                            const Text('异常',
                                style: TextStyle(color: Color(0xFF434343))),
                            const SizedBox(width: 4),
                            Text('${controller.faultDevicesRoom}',
                                style:
                                    const TextStyle(color: Color(0xFF434343)))
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                      width: 1,
                      height: 34,
                      color: const Color(0xFFE6E6E6),
                      margin: const EdgeInsets.symmetric(horizontal: 18)),
                  SizedBox(
                    width: 153,
                    height: 64,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('设备房',
                            style: TextStyle(color: Color(0xFF767676))),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('总计',
                                style: TextStyle(color: Color(0xFF434343))),
                            const SizedBox(width: 4),
                            Text('${controller.totalDevices}',
                                style:
                                    const TextStyle(color: Color(0xFF434343))),
                            const SizedBox(width: 16),
                            const Text('异常',
                                style: TextStyle(color: Color(0xFF434343))),
                            const SizedBox(width: 4),
                            Text('${controller.faultDevices}',
                                style:
                                    const TextStyle(color: Color(0xFF434343)))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
      const SizedBox(height: 12),
    ]);
  }
}
