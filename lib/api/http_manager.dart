import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_log/interceptor/dio_log_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:template/env/env_switcher.dart';

import '../global.dart';
import 'interceptors/handle_error_interceptor.dart';
import 'interceptors/loading_interceptor.dart';
import 'interceptors/request_token_interceptor.dart';
import 'rest_client.dart';

class HttpManager {
  static const connectTimeout = 60;
  static const receiveTimeout = 60;

  static final Map<String, dynamic> _optHeader = {
    'accept-language': 'zh-cn',
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  late RestClient client;

  HttpManager() {
    client = _createClient();
  }

  RestClient _createClient() {
    final dio = Dio(_createBaseOptions());
    // _addHTTPProxy(dio);
    _addInterceptorsConfig(dio);
    _addDioLogger(dio);
    return RestClient(dio);
  }

  BaseOptions _createBaseOptions() {
    return BaseOptions(
      connectTimeout: Duration(seconds: connectTimeout),
      receiveTimeout: Duration(seconds: receiveTimeout),
      baseUrl: currentConfig()[apiUrl],
      headers: _optHeader,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    );
  }

  void _addHTTPProxy(Dio dio) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () =>
          HttpClient()..findProxy = (uri) => "PROXY 10.239.9.190:443;",
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
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          enabled: kDebugMode,
          printRequestHeaders: true,
          printResponseHeaders: true,
        ),
      ),
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
      ),
    ]);
    dio.addSentry(captureFailedRequests: true);
  }
}
