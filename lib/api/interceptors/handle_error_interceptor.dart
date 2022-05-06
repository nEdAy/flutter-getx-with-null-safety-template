import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HandleErrorInterceptor extends InterceptorsWrapper {
  final String tokenHeader = 'access-token';

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      Get.defaultDialog(
          title: '提示',
          content: const Text('登录过期，请重新登录'),
          onConfirm: () => Get.back());
    } else {}
    super.onError(err, handler);
  }
}
