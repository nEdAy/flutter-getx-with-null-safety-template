import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    EasyLoading.show(status: 'loading...');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    EasyLoading.dismiss();
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    EasyLoading.dismiss();
    super.onError(err, handler);
  }
}
