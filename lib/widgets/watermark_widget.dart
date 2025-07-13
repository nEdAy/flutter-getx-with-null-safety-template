import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/common_utils.dart';

class WatermarkWidget extends StatelessWidget {
  const WatermarkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        children: _createColumnWidgets(),
      ),
    );
  }

  List<Widget> _createColumnWidgets() {
    List<Widget> list = [];
    for (var i = 0; i < 10; i++) {
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
                  angle: -pi / 5,
                  child:
                      Text(watermarkStr(), style: _handleTextStyle(isEven)))));
      list.add(widget);
    }
    return list;
  }

  TextStyle _handleTextStyle(bool isReverseColor) {
    // 根据屏幕 devicePixelRatio 对文本样式中长度相关的一些值乘以devicePixelRatio
    final devicePixelRatio = MediaQueryData.fromView(window).devicePixelRatio;
    var style = TextStyle(
        color:
            isReverseColor ? const Color(0x0A000000) : const Color(0x14FFFFFF),
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
}
