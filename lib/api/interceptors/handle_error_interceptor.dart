import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

class HandleErrorInterceptor extends InterceptorsWrapper {
  final String tokenHeader = 'access-token';

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      BotToast.showText(text: 'Session timeout, please login again');
      Future.delayed(const Duration(seconds: 1), () {
      });
    } else if (response.statusCode != 200) {
      BotToast.showText(text: 'Server exception');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      BotToast.showText(text: 'Session timeout, please login again');
      Future.delayed(const Duration(seconds: 1), () {
      });
    } else {
      BotToast.showText(text: 'Server exception');
    }
    super.onError(err, handler);
  }
}
