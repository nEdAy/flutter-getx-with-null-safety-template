import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/assets.gen.dart';

class ImageWidget extends StatefulWidget {
  final double width;
  final double height;

  final BoxShape? shape;
  final BorderRadius? borderRadius;

  final String? imageUrl;
  final Map<String, String>? headers;

  final File? file;
  final bool? enableMemoryCache;
  final bool? clearMemoryCacheWhenDispose;

  final Widget? loadingWidget;
  final Widget? emptyWidget;

  final GestureTapCallback? onImageTap;

  const ImageWidget(
      {super.key,
      required this.width,
      required this.height,
      this.shape,
      this.borderRadius,
      this.imageUrl,
      this.headers,
      this.file,
      this.enableMemoryCache,
      this.clearMemoryCacheWhenDispose,
      this.loadingWidget,
      this.emptyWidget,
      this.onImageTap});

  @override
  State<StatefulWidget> createState() {
    return _ImageWidgetState();
  }
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.imageUrl;
    final file = widget.file;
    if (imageUrl != null && imageUrl.isNotEmpty == true) {
      return _networkImage(imageUrl);
    } else if (file != null && file.existsSync() == true) {
      return _fileImage(file);
    } else {
      return widget.emptyWidget ??
          Container(
              width: widget.width,
              height: widget.height,
              color: const Color(0xFFF0F0F0));
    }
  }

  ExtendedImage _networkImage(String imageUrl) {
    return ExtendedImage.network(
      imageUrl,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
      headers: widget.headers,
      shape: widget.shape ?? BoxShape.rectangle,
      borderRadius: widget.borderRadius,
      cache: widget.enableMemoryCache ?? true,
      clearMemoryCacheWhenDispose: widget.clearMemoryCacheWhenDispose ?? false,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return _loadingWidget();
          case LoadState.completed:
            return _completedWidget(state);
          case LoadState.failed:
            return _failedWidget(state);
        }
      },
    );
  }

  ExtendedImage _fileImage(dynamic file) {
    return ExtendedImage.file(
      file,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
      clearMemoryCacheWhenDispose: widget.clearMemoryCacheWhenDispose ?? true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return _loadingWidget();
          case LoadState.completed:
            return _completedWidget(state);
          case LoadState.failed:
            return _failedWidget(state);
        }
      },
    );
  }

  Widget _loadingWidget() {
    return widget.loadingWidget ??
        Container(
          alignment: Alignment.center,
          color: const Color(0xFFE7E7E7),
          child: const SizedBox(
            height: 38,
            width: 38,
            child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Color(0xFFAAAAAA),
              strokeWidth: 6,
              semanticsLabel: 'Linear progress indicator',
            ),
          ),
        );
  }

  GestureDetector _completedWidget(ExtendedImageState state) {
    final onImageTap = widget.onImageTap;
    return GestureDetector(
        onTap: onImageTap,
        child: ExtendedRawImage(
          image: state.extendedImageInfo?.image,
          fit: BoxFit.fill,
        ));
  }

  Container _failedWidget(ExtendedImageState state) {
    double ratio = widget.width / 1.sw;
    if (ratio > 0.5) {
      return Container(
        color: const Color(0xFFE7E7E7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              Assets.images.common.iconLoadImageFailed.image().image,
              size: 48 * ratio,
              color: const Color(0xFFAAAAAA),
            ),
            SizedBox(height: 4 * ratio),
            Text('加载失败',
                style: TextStyle(
                  color: const Color(0xFF767676),
                  fontSize: 16 * ratio,
                )),
            SizedBox(height: 20 * ratio),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF0F0F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0 * ratio),
                ),
                minimumSize: Size(96 * ratio, 32 * ratio),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: const BorderSide(width: 1, color: Color(0xFFDCDCDC)),
              ),
              onPressed: () => state.reLoadImage(),
              child: Text('刷新重试',
                  style: TextStyle(
                    color: const Color(0xFF767676),
                    fontSize: 14 * ratio,
                  )),
            ),
          ],
        ),
      );
    } else {
      ratio = ratio * 2;
      return Container(
        color: const Color(0xFFE7E7E7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('加载失败',
                style: TextStyle(
                  color: const Color(0xFF767676),
                  fontSize: 16 * ratio,
                )),
            SizedBox(height: 8 * ratio),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF0F0F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0 * ratio),
                ),
                minimumSize: Size(96 * ratio, 32 * ratio),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: const BorderSide(width: 1, color: Color(0xFFDCDCDC)),
              ),
              onPressed: () => state.reLoadImage(),
              child: Text('刷新重试',
                  style: TextStyle(
                    color: const Color(0xFF767676),
                    fontSize: 14 * ratio,
                  )),
            ),
          ],
        ),
      );
    }
  }
}
