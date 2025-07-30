import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../store/store_manager.dart';
import 'date_util.dart';

List<String>? splitString(String? value, {Pattern pattern = ','}) {
  if (value != null && value.isNotEmpty) {
    return value.split(pattern);
  } else {
    return null;
  }
}

String? splitListToString(List<String>? value, {String pattern = ','}) {
  if (value != null && value.isNotEmpty) {
    return value.join(pattern);
  } else {
    return null;
  }
}

/// 解决中文和英文提前自动换行问题
extension FixAutoLines on String {
  String fixAutoLines() {
    return Characters(this).join('\u{200B}');
  }
}

Color colorReverse(Color oldColor) {
  final newRed = 255 - (oldColor.r * 255.0).round() & 0xff;
  final newGreen = 255 - (oldColor.g * 255.0).round() & 0xff;
  final newBlue = 255 - (oldColor.b * 255.0).round() & 0xff;
  final newColor = oldColor
      .withRed(newRed)
      .withGreen(newGreen)
      .withBlue(newBlue);
  return newColor;
}

String watermarkStr() {
  final lastUsername = StoreManager.instance.pref.getString(kLastUsername);
  final timestampStr = DateUtil.formatDate(
    DateTime.now(),
    format: DateFormats.y_mo_d_h_m,
  );
  final watermarkStr = '$lastUsername\n$timestampStr';
  return watermarkStr;
}

Color getExpiredTimeTextColor(String? expiredTime, {String? dateFormat}) {
  if (expiredTime != null && expiredTime.isNotEmpty) {
    DateFormat format;
    if (dateFormat != null && dateFormat.isNotEmpty) {
      format = DateFormat(dateFormat);
    } else {
      format = DateFormat(DateFormats.full);
    }
    final expiredDate = format.parse(expiredTime);
    final now = DateTime.now().toLocal();
    final differenceInHours = expiredDate.difference(now).inHours;
    if (differenceInHours >= 0) {
      if (differenceInHours <= 24) {
        return const Color(0xFFD91D00);
      } else if (differenceInHours <= 72) {
        return const Color(0xFFD97F00);
      }
    }
  }
  return const Color(0xFF000000);
}
