import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    } else {
                      index -= 1;
                      return _buildReportListViewItem(context, index);
                    }
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 12,
                      color: Colors.transparent,
                      indent: 20,
                      endIndent: 20,
                    );
                  },
                  itemCount: controller.reportItems.isEmpty
                      ? 1
                      : controller.reportItems.length + 1,
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  _buildHeaderView(BuildContext context) {
    return Column(
      children: [
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
                  style:
                      const TextStyle(color: Color(0xFF434343), fontSize: 16))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 153,
                        height: 64,
                        padding:
                            const EdgeInsets.only(left: 12, top: 8, bottom: 8),
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
                                    style: const TextStyle(
                                        color: Color(0xFF434343))),
                                const SizedBox(width: 16),
                                const Text('异常',
                                    style: TextStyle(color: Color(0xFF434343))),
                                const SizedBox(width: 4),
                                Text('${controller.faultDevicesRoom}',
                                    style: const TextStyle(
                                        color: Color(0xFF434343)))
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 34,
                        color: const Color(0xFFE6E6E6),
                      ),
                      Container(
                        width: 153,
                        height: 64,
                        padding:
                            const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('设备',
                                style: TextStyle(color: Color(0xFF767676))),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('总计',
                                    style: TextStyle(color: Color(0xFF434343))),
                                const SizedBox(width: 4),
                                Text('${controller.totalDevices}',
                                    style: const TextStyle(
                                        color: Color(0xFF434343))),
                                const SizedBox(width: 16),
                                const Text('异常',
                                    style: TextStyle(color: Color(0xFF434343))),
                                const SizedBox(width: 4),
                                Text('${controller.faultDevices}',
                                    style: const TextStyle(
                                        color: Color(0xFF434343)))
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  _buildReportListViewItem(BuildContext context, int index) {
    var reportItem = controller.reportItems[index];
    var isUnfold = false.obs;
    return Obx(
      () => Visibility(
        visible: !controller.isLoading.value,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  reportItem.abnormalEbaCount() > 0
                      ? Assets.images.iconReportItemHasError
                          .image(width: 16, height: 16)
                      : Assets.images.iconReportItemNoError
                          .image(width: 16, height: 16),
                  const SizedBox(width: 10),
                  Text(
                    reportItem.spaceName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Visibility(
                visible: reportItem.abnormalEbaCount() > 0,
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
                            '${reportItem.abnormalEbaCount()}',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFFD97F00),
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 4),
                          Obx(() {
                            return GestureDetector(
                              child: isUnfold.value
                                  ? const Icon(Icons.keyboard_arrow_up,
                                      color: Color(0xFF333333), size: 16)
                                  : const Icon(Icons.keyboard_arrow_down,
                                      color: Color(0xFF333333), size: 16),
                              onTap: () => isUnfold.value = !isUnfold.value,
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
                              margin: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, subIndex) {
                                var abnormalEbaDevice =
                                    controller.abnormalEbaDeviceList[subIndex];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      abnormalEbaDevice.deviceName ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF434343)),
                                    ),
                                    Text(
                                      abnormalEbaDevice.getStatusString(),
                                      style: const TextStyle(
                                          color: Color(0xFFD91D00)),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 12,
                                  color: Colors.transparent,
                                );
                              },
                              itemCount:
                                  controller.abnormalEbaDeviceList.length,
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
  }

  _buildBottomButton(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !controller.isLoading.value,
        child: Container(
          width: context.width,
          height: 82,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          color: Colors.white,
          child: ElevatedButton(
            onPressed: () => controller.launchURL(),
            child: const Text(
              '查看巡检报表',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(primary: const Color(0xFFFF9F08)),
          ),
        ),
      ),
    );
  }
}
