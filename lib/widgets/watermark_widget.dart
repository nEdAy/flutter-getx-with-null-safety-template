import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../config/user_info.dart';
import '../utils/date_util.dart';

class WatermarkWidget extends StatelessWidget {
  const WatermarkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: _createColumnWidgets(),
        ),
      ),
    );
  }

  List<Widget> _createColumnWidgets() {
    List<Widget> list = [];
    for (var i = 0; i < 5; i++) {
      final widget = Expanded(
          child: Row(
        children: _createRowWidgets(i.isEven),
      ));
      list.add(widget);
    }
    return list;
  }

  List<Widget> _createRowWidgets(bool isEven) {
    List<Widget> list = [];
    for (var i = 0; i < 2; i++) {
      final widget = Expanded(
          child: Center(
              child: Transform.rotate(
                  angle: pi / 10,
                  child:
                      Text(_watermarkStr(), style: _handleTextStyle(isEven)))));
      list.add(widget);
    }
    return list;
  }

  _handleTextStyle(bool isReverseColor) {
    // 根据屏幕 devicePixelRatio 对文本样式中长度相关的一些值乘以devicePixelRatio
    final devicePixelRatio = MediaQueryData.fromWindow(window).devicePixelRatio;
    var style = TextStyle(
        color: isReverseColor ? Colors.black38 : Colors.white38,
        fontSize: 10,
        decoration: TextDecoration.none);
    double scale(attr) => attr == null ? 1.0 : devicePixelRatio;
    return style.apply(
      decorationThicknessFactor: scale(style.decorationThickness),
      letterSpacingFactor: scale(style.letterSpacing),
      wordSpacingFactor: scale(style.wordSpacing),
      heightFactor: scale(style.height),
    );
  }

  _watermarkStr() {
    final userInfo = UserInfoConfig.instance.userInfo;
    final userName = userInfo.userName;
    final loginPhone = userInfo.loginPhone;
    final oaAccount = userInfo.oaAccount;
    final timestampStr = DateUtil.getNowDateStr();
    final watermarkStr = '$userName $loginPhone\n$oaAccount $timestampStr';
    return watermarkStr;
  }
}
