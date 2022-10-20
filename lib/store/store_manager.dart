import 'dart:async';

import 'package:isar/isar.dart';

import 'user_info.dart';

class StoreManager {
  final Isar isar;

  static late StoreManager _instance;

  factory StoreManager({
    required Isar isar,
  }) {
    _instance = StoreManager._internal(isar);
    return _instance;
  }

  StoreManager._internal(this.isar);

  static StoreManager get instance {
    return _instance;
  }

  /// 【同步】获取用户信息
  UserInfo? getUserInfoSync() {
    final userInfo = isar.userInfos.where().findFirstSync();
    return userInfo;
  }

  /// 【异步】存储用户信息
  Future<void> putUserInfo(UserInfo userInfo) async {
    await isar.writeTxn(() async {
      await isar.userInfos.clear();
      await isar.userInfos.put(userInfo);
    });
  }
}
