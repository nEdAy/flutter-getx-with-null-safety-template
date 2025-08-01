import 'package:dio/dio.dart';
import 'package:template/store/store_manager.dart';

class RequestTokenInterceptor extends InterceptorsWrapper {
  final String tokenHeader = 'access-token';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = StoreManager.instance.pref.getString(kAccessToken);
    final header = <String, String>{tokenHeader: ?accessToken};
    options.headers.addAll(header);
    super.onRequest(options, handler);
  }
}
