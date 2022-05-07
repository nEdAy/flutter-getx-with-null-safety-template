import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../channel/back_to_native.dart';
import '../../../channel/get_user_info.dart';
import '../../../config/flavor.dart';

class EbaReportDownload {
  final _dio = Dio();

  Future<void> downloadXLSFile(String url, CancelToken token) async {
    CancelFunc cancelLoadingFun = BotToast.showLoading(crossPage: false);
    final options = await _getDownloadOptions();
    if (options == null) {
      cancelLoadingFun();
      BotToast.showText(text: "登录过期，请重新登录");
      BackToNativeChannel.backToNative(isLogout: true);
      return;
    }
    final savePath = await _getSavePath();
    try {
      _download(url, savePath, cancelToken: token, options: options,
          onReceiveProgress: (received, total) async {
        if (total != -1) {
          if (!token.isCancelled) {
            var _downloadRatio = received / total;
            if (_downloadRatio == 1) {
              // 下载完成
              cancelLoadingFun();
              await OpenFile.open(savePath);
            }
          }
        }
      });
    } on DioError catch (error) {
      cancelLoadingFun();
      if (CancelToken.isCancel(error)) {
        BotToast.showText(text: "下载已取消");
      } else {
        Logger().e(error);
        BotToast.showText(text: "下载异常");
      }
    } on Exception catch (error) {
      Logger().e(error);
      cancelLoadingFun();
    }
  }

  Future<Options?> _getDownloadOptions() async {
    final userInfo = await GetUserInfo.getUserInfo();
    final String accessToken = userInfo?['accessToken'] ?? '';
    if (accessToken.isEmpty) {
      return null;
    }
    return Options(
      method: 'GET',
      headers: {
        'access-token': accessToken,
        'stage': FlavorConfig.instance.values.stage,
        'Group': 'device_info'
      },
    );
  }

  Future<String> _getSavePath() async {
    String _tempPath = "";
    if (Platform.isAndroid) {
      _tempPath = "/sdcard/download/";
    } else {
      _tempPath = (await getApplicationDocumentsDirectory()).path;
    }
    String _id= _idGenerator();
    String savePath = '$_tempPath/$_id.xls';
    return savePath;
  }

  String _idGenerator() {
    final uKey = UniqueKey().toString();
    final now = DateTime.now().microsecondsSinceEpoch.toString();
    return uKey + now;
  }

  void _download(
    String url,
    String savePath, {
    CancelToken? cancelToken,
    Options? options,
    void Function(int, int)? onReceiveProgress,
  }) async {
    await _dio.download(url, savePath,
        cancelToken: cancelToken,
        options: options,
        onReceiveProgress: onReceiveProgress);
  }
}
