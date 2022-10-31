import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '登录',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: controller.unameController,
                decoration: const InputDecoration(
                  labelText: '用户名',
                  hintText: '请输入用户名',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              Obx(
                () => TextFormField(
                  controller: controller.pwdController,
                  decoration: InputDecoration(
                      labelText: '密码',
                      hintText: '请输入密码',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(controller.pwdShow.isTrue
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => controller.pwdShow.value =
                            !controller.pwdShow.value,
                      )),
                  obscureText: !controller.pwdShow.value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(height: 55),
                  child: OutlinedButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      controller.onLoginPressed();
                    },
                    child: const Text('登录'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
