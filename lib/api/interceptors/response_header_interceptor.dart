import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ResponseHeaderInterceptor extends InterceptorsWrapper {
  final String tokenHeader = 'access-token';

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    var tokenValue = response.headers.value(tokenHeader);
    if (tokenValue != null) {
      Logger().i(tokenValue);
    }
    super.onResponse(response, handler);
  }
}
