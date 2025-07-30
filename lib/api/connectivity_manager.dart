// import 'dart:async';
//
// import 'package:flutter/services.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:logger/logger.dart';
//
// class ConnectionManagerController {
//   final isOnline = true.obs;
//   final InternetConnectionChecker _connectivity = InternetConnectionChecker.instance;
//   late StreamSubscription<InternetConnectionStatus> _streamSubscription;
//
//   @override
//   void onInit() {
//     super.onInit();
//     getConnectivityType();
//     _streamSubscription = _connectivity.onStatusChange.listen(_updateState);
//   }
//
//   Future<void> getConnectivityType() async {
//     late InternetConnectionStatus connectivityResult;
//     try {
//       connectivityResult = await _connectivity.connectionStatus;
//     } on PlatformException catch (error) {
//       Logger().e(error);
//     }
//     return _updateState(connectivityResult);
//   }
//
//   void _updateState(InternetConnectionStatus status) {
//     switch (status) {
//       case InternetConnectionStatus.connected:
//         Logger().d('Data connection is available.');
//         isOnline.value = true;
//         break;
//       case InternetConnectionStatus.disconnected:
//         Logger().d('You are disconnected from the internet.');
//         isOnline.value = false;
//         break;
//       case InternetConnectionStatus.slow:
//         // TODO: Handle this case.
//         break;
//     }
//   }
//
//   @override
//   void onClose() {
//     _streamSubscription.cancel();
//   }
// }
