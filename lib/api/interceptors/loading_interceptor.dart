import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

class LoadingInterceptor extends InterceptorsWrapper {
  late CancelFunc cancel;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.headers.containsKey('noLoading') ||
        options.headers['noLoading'] == false) {
      cancel = BotToast.showLoading(); // 弹出一个加载动画
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!response.requestOptions.headers.containsKey('noLoading') ||
        response.requestOptions.headers['noLoading'] == false) {
      cancel();
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (!err.requestOptions.headers.containsKey('noLoading') ||
        err.requestOptions.headers['noLoading'] == false) {
      cancel();
    }
    super.onError(err, handler);
  }
}
