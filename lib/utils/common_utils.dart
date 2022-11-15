import 'package:flutter/material.dart';

/// 解决中文和英文提前自动换行问题
extension FixAutoLines on String {
  String fixAutoLines() {
    return Characters(this).join('\u{200B}');
  }
}

Color colorReverse(Color oldColor) {
  final newRed = 255 - oldColor.red;
  final newGreen = 255 - oldColor.green;
  final newBlue = 255 - oldColor.red;
  final newColor =
      oldColor.withRed(newRed).withGreen(newGreen).withBlue(newBlue);
  return newColor;
}
