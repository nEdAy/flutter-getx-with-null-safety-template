import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';

class ConnectionManagerController extends GetxController {
  final isOnline = false.obs;
  final InternetConnectionChecker _connectivity = InternetConnectionChecker();
  late StreamSubscription _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    getConnectivityType();
    _streamSubscription = _connectivity.onStatusChange.listen(_updateState);
  }

  Future<void> getConnectivityType() async {
    late InternetConnectionStatus connectivityResult;
    try {
      connectivityResult = await _connectivity.connectionStatus;
    } on PlatformException catch (error) {
      Logger().e(error);
    }
    return _updateState(connectivityResult);
  }

  _updateState(InternetConnectionStatus status) {
    switch (status) {
      case InternetConnectionStatus.connected:
        Logger().d('Data connection is available.');
        isOnline.value = true;
        break;
      case InternetConnectionStatus.disconnected:
        Logger().d('You are disconnected from the internet.');
        isOnline.value = false;
        break;
    }
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
  }
}
