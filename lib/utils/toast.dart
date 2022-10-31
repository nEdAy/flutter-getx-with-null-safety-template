import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/assets.gen.dart';

showCenterToast(
  String text, {
  bool isShowImage = true,
  ImageProvider? imageProvider,
  VoidCallback? onClose,
}) {
  BotToast.showAttachedWidget(
    attachedBuilder: (_) => Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isShowImage == true ? 16 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isShowImage == true
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageIcon(
                      imageProvider ??
                          Assets.images.common.iconToastSuccess.image().image,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                  ],
                )
              : const SizedBox.shrink(),
          Text(
            text,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    onlyOne: true,
    duration: const Duration(seconds: 2),
    target: Offset(1.sw / 2, 1.sh / 2),
    onClose: onClose,
  );
}
