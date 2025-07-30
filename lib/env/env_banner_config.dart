import 'package:flutter/material.dart';

/// EnvBannerConfig to configure flavors
class EnvBannerConfig {
  /// Name of env
  final String envName;

  /// Color of the banner
  final Color color;

  /// Location of the banner
  final BannerLocation location;

  /// Private constructor
  EnvBannerConfig._internal(this.envName, this.color, this.location);

  /// Internal instance of FlavorConfig
  static EnvBannerConfig? _instance;

  /// Instance of FlavorConfig
  static EnvBannerConfig? get instance {
    return _instance;
  }

  /// Factory constructor
  factory EnvBannerConfig(
    String env, {
    Color color = Colors.red,
    BannerLocation location = BannerLocation.topStart,
  }) {
    _instance = EnvBannerConfig._internal(env, color, location);
    return _instance!;
  }
}
