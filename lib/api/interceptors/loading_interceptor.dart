import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

class LoadingInterceptor extends InterceptorsWrapper {
  late CancelFunc cancel;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    cancel = BotToast.showLoading(); //弹出一个加载动画
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    cancel();
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    cancel();
    super.onError(err, handler);
  }
}
