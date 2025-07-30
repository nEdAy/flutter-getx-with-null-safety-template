// import 'package:bot_toast/bot_toast.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
//
// import '../../../api/rest_client.dart';
// import '../../../store/store_manager.dart';
//
// class LoginController extends GetxController {
//   late final String? route;
//   late final dynamic arguments;
//
//   final RestClient client;
//
//   final TextEditingController unameController = TextEditingController();
//   final TextEditingController pwdController = TextEditingController();
//   final pwdShow = false.obs;
//
//   LoginController({required this.client});
//
//   @override
//   void onInit() {
//     super.onInit();
//     route = Get.arguments['route'];
//     arguments = Get.arguments['arguments'];
//     final lastUsername = StoreManager.instance.pref.getString(kLastUsername);
//     if (lastUsername != null) {
//       unameController.text = lastUsername;
//     }
//   }
//
//   void onLoginPressed() {
//     final username = unameController.value.text;
//     final password = pwdController.value.text;
//     const token = 'token';
//     if (password.isNotEmpty && token.isNotEmpty) {
//       StoreManager.instance.pref.setString(kAccessToken, token);
//       _onAuthSuccess(username);
//     } else {
//       BotToast.showText(text: '登录失败');
//     }
//   }
//
//   void _onAuthSuccess(String username) {
//     final route = this.route;
//     if (route != null) {
//       StoreManager.instance.pref.setString(kLastUsername, username);
//       Get.offAndToNamed(route, arguments: arguments);
//     } else {
//       BotToast.showText(text: '路由配置异常');
//     }
//   }
// }
