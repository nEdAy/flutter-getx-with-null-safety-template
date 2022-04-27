import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

class LoadingInterceptor extends InterceptorsWrapper {
  final Map<String, CancelFunc> _cancelMap = {};

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.headers.containsKey('noLoading') ||
        options.headers['noLoading'] == false) {
      CancelFunc cancel = BotToast.showLoading();
      _cancelMap.addAll({options.uri.toString(): cancel});
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    cancelLoading(response.requestOptions);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    cancelLoading(err.requestOptions);
    super.onError(err, handler);
  }

  void cancelLoading(RequestOptions requestOptions) {
    if (!requestOptions.headers.containsKey('noLoading') ||
        requestOptions.headers['noLoading'] == false) {
      final requestKey = requestOptions.uri.toString();
      if (_cancelMap.containsKey(requestKey)) {
        CancelFunc? cancel = _cancelMap[requestKey];
        if (cancel != null) {
          cancel();
          _cancelMap.remove(requestKey);
        }
      }
    }
  }
}
