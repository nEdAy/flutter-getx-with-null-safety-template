import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatefulWidget {
  final double width;
  final double height;

  final String? imageUrl;
  final Map<String, String>? headers;

  final File? file;
  final bool? enableMemoryCache;
  final bool? clearMemoryCacheWhenDispose;

  final GestureTapCallback? onImageTap;

  const ImageWidget({Key? key,
    required this.width,
    required this.height,
    this.imageUrl,
    this.headers,
    this.file,
    this.enableMemoryCache,
    this.clearMemoryCacheWhenDispose,
    this.onImageTap})
      : super(key: key);

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
      return Container(
          width: widget.width,
          height: widget.height,
          color: const Color(0xFFF0F0F0));
    }
  }

  _networkImage(String imageUrl) {
    return ExtendedImage.network(
      imageUrl,
      width: widget.width,
      height: widget.height,
      headers: widget.headers,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Container(color: const Color(0xFFF0F0F0));
          case LoadState.completed:
            final onImageTap = widget.onImageTap;
            return GestureDetector(
                onTap: onImageTap != null ? () => onImageTap() : null,
                child: ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  fit: BoxFit.fill,
                ));
          case LoadState.failed:
            return Container(color: const Color(0xFFF0F0F0));
            // return GestureDetector(
            //   child: Container(color: const Color(0xFFF0F0F0)),
            //   onTap: () => state.reLoadImage(),
            // );
        }
      },
    );
  }

  _fileImage(File file) {
    return ExtendedImage.file(
      file,
      width: widget.width,
      height: widget.height,
      enableMemoryCache: widget.enableMemoryCache ?? false,
      clearMemoryCacheWhenDispose:
      widget.clearMemoryCacheWhenDispose ?? true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Container(color: const Color(0xFFF0F0F0));
          case LoadState.completed:
            final onImageTap = widget.onImageTap;
            return GestureDetector(
                onTap: onImageTap != null ? () => onImageTap() : null,
                child: ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  fit: BoxFit.fill,
                ));
          case LoadState.failed:
            return GestureDetector(
              child: Container(color: const Color(0xFFF0F0F0)),
              onTap: () => state.reLoadImage(),
            );
        }
      },
    );
  }
}
