/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************
import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/flutter_logo.png
  AssetGenImage get flutterLogo =>
      const AssetGenImage('assets/images/flutter_logo.png');

  /// File path: assets/images/icon_alarm.png
  AssetGenImage get iconAlarm =>
      const AssetGenImage('assets/images/icon_alarm.png');

  /// File path: assets/images/icon_arrow_drop_down.png
  AssetGenImage get iconArrowDropDown =>
      const AssetGenImage('assets/images/icon_arrow_drop_down.png');

  /// File path: assets/images/icon_arrow_drop_down_active.png
  AssetGenImage get iconArrowDropDownActive =>
      const AssetGenImage('assets/images/icon_arrow_drop_down_active.png');

  /// File path: assets/images/icon_report.png
  AssetGenImage get iconReport =>
      const AssetGenImage('assets/images/icon_report.png');

  /// File path: assets/images/icon_report_has_error.png
  AssetGenImage get iconReportHasError =>
      const AssetGenImage('assets/images/icon_report_has_error.png');

  /// File path: assets/images/icon_report_item_has_error.png
  AssetGenImage get iconReportItemHasError =>
      const AssetGenImage('assets/images/icon_report_item_has_error.png');

  /// File path: assets/images/icon_report_item_no_error.png
  AssetGenImage get iconReportItemNoError =>
      const AssetGenImage('assets/images/icon_report_item_no_error.png');

  /// File path: assets/images/icon_report_has_error.png
  AssetGenImage get iconReportNoError =>
      const AssetGenImage('assets/images/icon_report_has_error.png');
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
