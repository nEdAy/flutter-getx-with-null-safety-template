import 'package:flutter/material.dart';

const String prod = 'prod';
const String pre = 'pre';
const String uat = 'uat';
const String sit = 'sit';

const uatBaseUrl = "https://zhsq-iot-api.sunac.com.cn";
const prodBaseUrl = "https://zhsq-iot-uat-api.sunac.com.cn";

class FlavorValues {
  final String baseUrl;
  final String stage;

  FlavorValues({required this.baseUrl,required this.stage});
}

class FlavorConfig {
  final String flavor;
  final Color color;
  final FlavorValues values;
  static late FlavorConfig _instance;

  factory FlavorConfig({
    required String flavor,
    required FlavorValues values,
    Color color = Colors.blue,
  }) {
    _instance = FlavorConfig._internal(flavor, values, color);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.values, this.color);

  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.flavor == prod;

  static bool isPreProduction() => _instance.flavor == pre;

  static bool isQA() => _instance.flavor == uat;

  static bool isDevelopment() => _instance.flavor == sit;
}
