import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/user_info.dart';
import 'date_util.dart';

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

String watermarkStr() {
  final userInfo = UserInfoConfig.instance.userInfo;
  final userName = userInfo.userName;
  final loginPhone = userInfo.loginPhone;
  final oaAccount = userInfo.oaAccount;
  final timestampStr =
      DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d_h_m);
  final watermarkStr = '$userName $loginPhone\n$oaAccount $timestampStr';
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
    final differenceInDays = expiredDate.difference(now).inDays;
    if (differenceInDays >= 0) {
      if (differenceInDays <= 1) {
        return const Color(0xFFFF0068);
      } else if (differenceInDays <= 3) {
        return const Color(0xFFD97F00);
      }
    }
  }
  return const Color(0xFF000000);
}
