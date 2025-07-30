import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../routes/app_pages.dart';
import 'env_banner_config.dart';
import 'env_switcher.dart';

/// Widget for draw banner
class EnvBanner extends HookConsumerWidget {
  /// Widget inside EnvBanner
  final Widget child;

  /// Color of the banner
  final Color? color;

  /// Location of the banner
  final BannerLocation? location;

  const EnvBanner({super.key, required this.child, this.color, this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = EnvBannerConfig.instance;
    if (config != null) {
      return GestureDetector(
        onDoubleTap: () => EnvSwitcher.showEnvSwitcherDialog(
          navigatorGlobalKey.currentContext!,
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Banner(
            color: color ?? config.color,
            message: config.envName,
            location: location ?? config.location,
            textStyle: TextStyle(
              color: HSLColor.fromColor(color ?? config.color).lightness < 0.8
                  ? Colors.white
                  : Colors.black87,
              fontSize: 12.0 * 0.85,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
            child: child,
          ),
        ),
      );
    }
    return child;
  }
}
