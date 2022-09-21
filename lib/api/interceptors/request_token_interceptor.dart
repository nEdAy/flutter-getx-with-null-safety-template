import 'package:dio/dio.dart';

import '../../config/user_info.dart';

class RequestTokenInterceptor extends InterceptorsWrapper {
  final String tokenHeader = 'access-token';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = UserInfoConfig.getToken();
    final header = <String, String>{tokenHeader: accessToken};
    options.headers.addAll(header);
    super.onRequest(options, handler);
  }
}
