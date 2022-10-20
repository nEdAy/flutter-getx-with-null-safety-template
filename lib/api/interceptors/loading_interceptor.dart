import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

import '../../utils/date_util.dart';

class LoadingInterceptor extends InterceptorsWrapper {
  final Map<String, CancelFunc> _cancelMap = {};
  static const String requestKey = 'requestKey';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.headers.containsKey('noLoading') ||
        options.headers['noLoading'] == false) {
      CancelFunc cancel = BotToast.showLoading();
      final requestKeyValue = '${options.uri}-${DateUtil.getNowDateMs()}';
      options.extra = {requestKey: requestKeyValue};
      _cancelMap.putIfAbsent(requestKeyValue, () => cancel);
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
      final extra = requestOptions.extra;
      if (extra.containsKey(requestKey)) {
        final requestKeyValue = extra[requestKey];
        if (_cancelMap.containsKey(requestKeyValue)) {
          CancelFunc? cancel = _cancelMap[requestKeyValue];
          if (cancel != null) {
            cancel();
            _cancelMap.remove(requestKeyValue);
          }
        }
      }
    }
  }
}
