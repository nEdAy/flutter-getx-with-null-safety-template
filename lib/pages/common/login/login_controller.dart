import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../api/rest_client.dart';
import '../../../config/user_info.dart';
import '../../../store/store_manager.dart';
import '../../../store/user_info.dart';

class LoginController extends GetxController {
  late final String? route;
  late final dynamic arguments;

  final RestClient client;

  final TextEditingController unameController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final pwdShow = false.obs;

  LoginController({required this.client});

  @override
  void onInit() {
    super.onInit();
    route = Get.arguments['route'];
    arguments = Get.arguments['arguments'];
    final lastUserInfo = UserInfoConfig.instance.userInfo;
    final lastUsername = lastUserInfo.oaAccount;
    if (lastUsername != null) {
      unameController.text = lastUsername;
    }
    final lastPassword = lastUserInfo.password;
    if (lastPassword != null) {
      pwdController.text = lastPassword;
    }
  }

  onLoginPressed() {
    final username = unameController.value.text;
    final password = pwdController.value.text;
    const token = 'token';
    const memberId = 'memberId';
    // if (token != null && memberId != null) {
    _onAuthSuccess(username, password, token, memberId);
    // } else {
    //   BotToast.showText(text: '登录失败');
    // }
  }

  _onAuthSuccess(
      String username, String password, String token, String memberId) {
    final route = this.route;
    if (route != null) {
      final userInfo = UserInfo(
        oaAccount: username,
        password: password,
        token: token,
        memberId: memberId,
      );
      StoreManager.instance.putUserInfo(userInfo);
      UserInfoConfig(userInfo: userInfo);
      Get.offAndToNamed(route, arguments: arguments);
    } else {
      BotToast.showText(text: '路由配置异常');
    }
  }
}
