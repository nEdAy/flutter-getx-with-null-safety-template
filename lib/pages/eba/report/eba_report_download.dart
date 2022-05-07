import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../channel/get_user_info.dart';
import '../../../config/flavor.dart';

class EbaReportDownload {
  Future<void> downloadXLSFile(String url, CancelToken token) async {
    CancelFunc cancelLoadingFun = BotToast.showLoading(crossPage: false);
    final options = await _getDownloadOptions();
    if (options == null) {
      cancelLoadingFun();
      BotToast.showText(text: "登录过期，请重新登录");
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
    } on DioError catch (e) {
      cancelLoadingFun();
      if (CancelToken.isCancel(e)) {
        BotToast.showText(text: "下载已取消");
      } else {
        BotToast.showText(text: "下载异常");
      }
    } on Exception catch (e) {
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
    Directory tempDir = await getTemporaryDirectory();
    String _tempPath = tempDir.path;
    String savePath = '$_tempPath/$_idGenerator.xls';
    return savePath;
  }

  void _download(
    String url,
    String savePath, {
    CancelToken? cancelToken,
    Options? options,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final dio = Dio();
    await dio.download(url, savePath,
        cancelToken: cancelToken,
        options: options,
        onReceiveProgress: onReceiveProgress);
  }

  String _idGenerator() {
    final uKey = UniqueKey().toString();
    final now = DateTime.now().microsecondsSinceEpoch.toString();
    return uKey + now;
  }
}
