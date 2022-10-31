import 'package:dio/dio.dart';
import 'package:dio_log/interceptor/dio_log_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';

import '../config/flavor.dart';
import 'interceptors/interceptors.dart';
import 'rest_client.dart';

class HttpManager {
  // 超时时间 60s
  static const connectTimeout = 60000;
  static const receiveTimeout = 60000;

  static final Map<String, dynamic> _optHeader = {
    'accept-language': 'zh-cn',
    'content-type': 'application/json',
    'accept': 'application/json'
  };

  late RestClient client;

  HttpManager() {
    client = _createClient();
  }

  RestClient _createClient() {
    final dio = Dio(_createBaseOptions());
    _addInterceptorsConfig(dio);
    _addDioLogger(dio);
    return RestClient(dio);
  }

  BaseOptions _createBaseOptions() {
    return BaseOptions(
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      baseUrl: FlavorConfig.instance.values.baseUrl,
      headers: _optHeader,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    );
  }

  void _addInterceptorsConfig(Dio dio) {
    dio.interceptors.addAll([
      LoadingInterceptor(),
      RequestTokenInterceptor(),
      HandleErrorInterceptor(),
    ]);
  }

  void _addDioLogger(Dio dio, {bool printResponseBody = true}) {
    DioLogInterceptor.enablePrintLog = false;
    dio.interceptors.addAll([
      // logcat print (enablePrintLog = false)
      DioLogInterceptor(),
      // flutter debug console
      PrettyDioLogger(
        requestHeader: true,
        queryParameters: true,
        requestBody: true,
        responseHeader: true,
        responseBody: printResponseBody,
        showCUrl: true,
        canShowLog: kDebugMode,
      )
    ]);
  }
}
