import 'package:dio/dio.dart';

class RequestHeaderInterceptor extends InterceptorsWrapper {
  final String tokenHeader = 'token';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var header = <String, String>{tokenHeader: "token"};
    options.headers.addAll(header);
    super.onRequest(options, handler);
  }
}
