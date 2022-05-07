import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

import '../../channel/back_to_native.dart';

class HandleErrorInterceptor extends InterceptorsWrapper {
  final String tokenHeader = 'access-token';

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      BotToast.showText(text: "登录过期，请重新登录");
      BackToNativeChannel.backToNative(isLogout: true);
    } else if (response.statusCode != 200) {
      BotToast.showText(text: "请求服务器异常");
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      BotToast.showText(text: "登录过期，请重新登录");
      BackToNativeChannel.backToNative(isLogout: true);
    } else {
      BotToast.showText(text: "请求服务器异常");
    }
    super.onError(err, handler);
  }
}
