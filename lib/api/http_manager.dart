import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
import 'package:dio_log/interceptor/dio_log_interceptor.dart';
import 'package:sunac_flutter/config/flavor.dart';

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
    'accept': 'application/json',
    'stage': FlavorConfig.instance.values.stage
  };

  late RestClient client;

  HttpManager() {
    client = _createClient();
  }

  RestClient _createClient() {
    final dio = Dio(_createBaseOptions());
    _addCertificateConfig(dio);
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
        });
  }

  void _addCertificateConfig(Dio dio) {
    // 当环境为DEV的时候，证书校验忽略，直接返回 true
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };
  }

  void _addInterceptorsConfig(Dio dio) {
    dio.interceptors.addAll([
      LoadingInterceptor(),
      RequestHeaderInterceptor(),
      HandleErrorInterceptor(),
    ]);
  }

  void _addDioLogger(Dio dio, {bool printResponseBody = true}) {
    dio.interceptors.addAll([
      DioLogInterceptor(),
      HttpFormatter(includeResponseBody: printResponseBody),
    ]);
  }
}
