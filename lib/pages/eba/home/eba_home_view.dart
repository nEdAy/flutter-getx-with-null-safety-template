import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/response/eba/project_list_response/project_list_response.dart';
import '../../../channel/back_to_native.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/highlight_text.dart';
import 'eba_home_controller.dart';

class EbaHomeView extends GetView<EbaHomeController> {
  const EbaHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('EBA',
            style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () => BackToNativeChannel.backToNative(),
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 16,
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        // bottom: false,
        child: Column(
          children: <Widget>[
            _buildProjectDropDownButton(context),
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: controller.isDropDownActive.value ? 1 : 0,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        _buildProjectDataDisplayBox(context),
                        _buildClickableCardButton(
                            Assets.images.iconAlarm,
                            '告警',
                            () => Get.toNamed(Routes.ebaAlarm,
                                arguments: controller.currentProjectId.value)),
                        _buildClickableCardButton(
                            Assets.images.iconReport,
                            '一键巡检',
                            () => Get.toNamed(Routes.ebaReport,
                                arguments: controller.currentProjectId.value)),
                      ],
                    ),
                    _buildDropdownSearchList(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildProjectDropDownButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => ConstrainedBox(
                constraints: BoxConstraints(maxWidth: context.width / 2),
                child: Text('${controller.currentProjectName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: controller.isDropDownActive.value
                            ? const Color(0xFFD97F00)
                            : const Color(0xFF434343),
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.allProjectItems.length > 1,
                child: controller.isDropDownActive.value
                    ? Assets.images.iconArrowDropDownActive
                        .image(width: 16, height: 16)
                    : Assets.images.iconArrowDropDown
                        .image(width: 16, height: 16),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        controller.onDropDownTap();
      },
    );
  }

  _buildProjectDataDisplayBox(BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      height: 248,
      color: const Color(0xFF2D2C2B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('监控设备数量',
              style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16)),
          const SizedBox(height: 12),
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
                  style: TextStyle(color: Color(0xFF999999), fontSize: 14),
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
                  style: TextStyle(color: Color(0xFF999999), fontSize: 14),
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
                    style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('告警数量',
              style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16)),
          const SizedBox(height: 12),
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
                  style: TextStyle(color: Color(0xFF999999), fontSize: 14),
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
                    style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                  )
                ],
              ),
              const SizedBox(),
              const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  _buildClickableCardButton(
      AssetGenImage iconImage, String text, GestureTapCallback onTap) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: Container(
          height: 100,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: iconImage.image(width: 40, height: 40),
            title: Text(
              text,
              style: const TextStyle(
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
      onTap: onTap,
    );
  }

  _buildDropdownSearchList(BuildContext context) {
    return Column(
      children: <Widget>[
        const Divider(
          thickness: 1,
          height: 1,
          color: Color(0xFFF0F0F0),
        ),
        Container(
          width: context.width,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: Colors.white,
          child: Obx(
            () => TextField(
              controller: controller.projectSearchController,
              focusNode: controller.focusNode,
              cursorColor: const Color(0xFF767676),
              cursorWidth: 1,
              style: const TextStyle(
                  color: Color(0xFF434343),
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                prefixIcon: Assets.images.iconProjectSearch
                    .image(width: 16, height: 16),
                prefixIconConstraints: const BoxConstraints(minWidth: 40),
                fillColor: Colors.white,
                filled: true,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE6E6E6)),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                hintText: '${controller.projectSearchHintText}',
                hintStyle: const TextStyle(
                    color: Color(0xFF767676),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                hintMaxLines: 1,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE6E6E6)),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              onChanged: (value) {
                controller.onSearchInputChanged(value);
              },
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Obx(
            () => ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Obx(
                      () {
                        var projectName =
                            controller.filteredProjectItems[index].name;
                        var isCurrentProject =
                            projectName == controller.currentProjectName.value;
                        return HighlightText(
                          text: projectName ?? '',
                          textStyle: TextStyle(
                            color: isCurrentProject
                                ? const Color(0xFFD97F00)
                                : const Color(0xFF434343),
                            fontWeight: isCurrentProject
                                ? FontWeight.w500
                                : FontWeight.w400,
                            fontSize: 16,
                          ),
                          lightText: controller.projectSearchKeyword.value,
                          lightStyle: const TextStyle(
                            color: Color(0xFFD97F00),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    List<Project> projectList = controller.filteredProjectItems;
                    controller.onProjectSearchItemClick(projectList[index]);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                  indent: 20,
                  endIndent: 20,
                );
              },
              itemCount: controller.filteredProjectItems.length,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            child: Container(
              width: context.width,
              color: const Color(0x80000000),
            ),
            onTap: () => controller.switchDropDownToInactive(),
          ),
        ),
      ],
    );
  }
}
