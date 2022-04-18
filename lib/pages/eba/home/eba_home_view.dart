import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/app_pages.dart';
import 'eba_home_controller.dart';

class EbaHomeView extends GetView<EbaHomeController> {
  const EbaHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> items = [
      '天津融创中心',
      '天津融创中心2',
      '天津融创中心3',
      '天津融创中心4',
    ];
    String? selectedValue = items[0];
    List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
      List<DropdownMenuItem<String>> _menuItems = [];
      for (var item in items) {
        _menuItems.addAll(
          [
            DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            // If it's last item, we will not add Divider after it.
            if (item != items.last)
              const DropdownMenuItem<String>(
                enabled: false,
                child: Divider(),
              ),
          ],
        );
      }
      return _menuItems;
    }

    List<int> _getDividersIndexes() {
      List<int> _dividersIndexes = [];
      for (var i = 0; i < (items.length * 2) - 1; i++) {
        // Dividers indexes will be the odd indexes
        if (i.isOdd) {
          _dividersIndexes.add(i);
        }
      }
      return _dividersIndexes;
    }

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
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                    isExpanded: true,
                    items: _addDividersAfterItems(items),
                    customItemsIndexes: _getDividersIndexes(),
                    customItemsHeight: 4,
                    value: selectedValue,
                    onChanged: (value) {},
                    iconEnabledColor: Colors.blue,
                    iconDisabledColor: Colors.red,
                    dropdownMaxHeight: 160,
                    selectedItemHighlightColor: Colors.yellow,
                    scrollbarAlwaysShow: false,
                    buttonHeight: 40,
                    itemHeight: 40,
                    style: const TextStyle(color: Color(0xFF434343)),
                    itemPadding: const EdgeInsets.symmetric(horizontal: 8.0)),
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
                          '验证告警',
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