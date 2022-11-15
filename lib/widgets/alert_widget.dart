import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertWidget extends StatelessWidget {
  final String title;
  final String submitTitle;
  final String cancelTitle;
  final VoidCallback? cancelCallBack;
  final VoidCallback? submitCallBack;

  const AlertWidget(
      {Key? key,
      required this.title,
      this.cancelCallBack,
      this.submitCallBack,
      required this.submitTitle,
      required this.cancelTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x1E000000), //设置为透明色
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: context.width,
              constraints: const BoxConstraints(minHeight: 180),
              margin: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('确认取消吗？',
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none))),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 50),
                        child: const Text('将不保存已编辑内容',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xff434343),
                                decoration: TextDecoration.none)),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                          height: 60,
                          width: context.width,
                          child: Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 0.5,
                                          style: BorderStyle.solid,
                                          color: Colors.black26)),
                                  child: const Text('取消',
                                      style: TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.none,
                                          color: Colors.black)),
                                ),
                                onTap: () {
                                  Get.back();
                                },
                              )),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        if (submitCallBack != null) {
                                          submitCallBack!();
                                        }
                                        Get.back();
                                      },
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5.0)),
                                            color: const Color(0xfffbefee),
                                            border: Border.all(
                                                width: 1,
                                                style: BorderStyle.solid,
                                                color:
                                                    const Color(0xfff7d2cc))),
                                        child: const Text('确认取消',
                                            style: TextStyle(
                                                fontSize: 18,
                                                decoration: TextDecoration.none,
                                                color: Color(0xffd91d00),
                                                fontWeight: FontWeight.w600)),
                                      ))),
                            ],
                          ))),
                ],
              )),
        ],
      )),
    );
  }
}
