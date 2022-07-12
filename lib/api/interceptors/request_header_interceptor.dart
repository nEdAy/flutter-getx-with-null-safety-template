import 'package:dio/dio.dart';

import '../../channel/get_user_info.dart';

class RequestHeaderInterceptor extends InterceptorsWrapper {
  final String tokenHeader = 'access-token';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var userInfo  = {}; // await GetUserInfo.getUserInfo();
    var header = <String, String>{tokenHeader: userInfo['accessToken'] ?? ""};
    options.headers.addAll(header);
    super.onRequest(options, handler);
  }
}
