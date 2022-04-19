import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/app_pages.dart';
import 'eba_home_controller.dart';

class EbaHomeView extends GetView<EbaHomeController> {
  const EbaHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EBA',
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
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 54,
              child: GestureDetector(
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${controller.projectName}',
                          style: TextStyle(
                              color: controller.isDropDownActive.value
                                  ? const Color(0xFFD97F00)
                                  : const Color(0xFF434343),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      controller.items.length > 1
                          ? (controller.isDropDownActive.value
                              ? Assets.images.iconArrowDropDownActive
                                  .image(width: 16, height: 16)
                              : Assets.images.iconArrowDropDown
                                  .image(width: 16, height: 16))
                          : Container()
                    ],
                  ),
                ),
                onTap: () => controller.onDropDownTap(),
              ),
            ),
            Container(
              width: context.width,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              height: 248,
              color: const Color(0xFF2D2C2B),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('监控设备数量',
                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16)),
                  Container(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        Obx(() => Text(
                              '${controller.totalDevices}',
                              style: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22),
                            )),
                        const Text(
                          '设备总数',
                          style:
                              TextStyle(color: Color(0xFF999999), fontSize: 14),
                        )
                      ]),
                      Column(children: [
                        Obx(() => Text(
                              '${controller.faultDevices}',
                              style: const TextStyle(
                                  color: Color(0xFFE87766),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22),
                            )),
                        const Text(
                          '故障设备',
                          style:
                              TextStyle(color: Color(0xFF999999), fontSize: 14),
                        )
                      ]),
                      Column(
                        children: [
                          Obx(() => Text(
                                '${controller.disableDevices}',
                                style: const TextStyle(
                                    color: Color(0xFF767676),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22),
                              )),
                          const Text(
                            '停用设备',
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 14),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(height: 32),
                  const Text('告警数量',
                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16)),
                  Container(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        Obx(() => Text(
                              '${controller.majorAlarm}',
                              style: const TextStyle(
                                  color: Color(0xFFFF9F08),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22),
                            )),
                        const Text(
                          '严重告警',
                          style:
                              TextStyle(color: Color(0xFF999999), fontSize: 14),
                        )
                      ]),
                      Column(
                        children: [
                          Obx(() => Text(
                                '${controller.minorAlarm}',
                                style: const TextStyle(
                                    color: Color(0xFFFFBC52),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22),
                              )),
                          const Text(
                            '一般告警',
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 14),
                          )
                        ],
                      ),
                      Container(),
                      Container(),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Card(
                margin: const EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    leading:
                        Assets.images.iconAlarm.image(width: 40, height: 40),
                    title: const Text(
                      '告警',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              onTap: () => Get.toNamed(Routes.ebaAlarm),
            ),
            GestureDetector(
              child: Card(
                margin: const EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    leading:
                        Assets.images.iconReport.image(width: 40, height: 40),
                    title: const Text(
                      '一键巡检',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
              ),
              onTap: () => Get.toNamed(Routes.ebaReport),
            ),
          ],
        ),
      ),
    );
  }
}
