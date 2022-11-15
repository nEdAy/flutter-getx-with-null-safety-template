import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

class ImageTools {
  // 拿到图片的字节数组
  Future<ui.Image> loadImageByFile(String path) async {
    final list = await File(path).readAsBytes();
    return loadImageByUint8List(list);
  }

  // 通过[Uint8List]获取图片
  Future<ui.Image> loadImageByUint8List(Uint8List list) async {
    final ui.Codec codec = await ui.instantiateImageCodec(list);
    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  // 通过provider获取image
  Future<ui.Image> loadImageByProvider(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    final Completer<ui.Image> completer = Completer<ui.Image>(); // 完成的回调
    ImageStreamListener? listener;
    final ImageStream stream = provider.resolve(config); // 获取图片流
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      // 监听
      final ui.Image image = frame.image;
      completer.complete(image); // 完成
      if (listener != null) {
        stream.removeListener(listener); // 移除监听
      }
    });
    stream.addListener(listener); // 添加监听
    return completer.future; // 返回
  }
}
