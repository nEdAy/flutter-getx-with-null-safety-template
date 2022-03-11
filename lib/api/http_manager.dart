import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
import 'package:network_inspector/common/utils/dio_interceptor.dart';
import 'package:network_inspector/network_inspector.dart';

import '../config/config.dart';
import 'interceptors/interceptors.dart';
import 'rest_client.dart';

class HttpManager {
  // 超时时间 120s
  static const connectTimeout = 120000;
  static const receiveTimeout = 120000;

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
    _addCertificateConfig(dio);
    _addInterceptorsConfig(dio);
    _addDioLogger(dio);
    return RestClient(dio);
  }

  BaseOptions _createBaseOptions() {
    return BaseOptions(
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        baseUrl: baseUrl,
        headers: _optHeader,
        setRequestContentTypeWhenNoPayload: true,
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
      ResponseHeaderInterceptor(),
    ]);
  }

  void _addDioLogger(Dio dio, {bool printResponseBody = true}) {
    dio.interceptors.addAll([
      HttpFormatter(includeResponseBody: printResponseBody),
      DioInterceptor(
        logIsAllowed: true,
        networkInspector: NetworkInspector(),
      ),
    ]);
  }
}
