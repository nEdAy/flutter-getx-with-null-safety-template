import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';

showCenterToast(String text,
    {ImageProvider? imageProvider, VoidCallback? onClose}) {
  BotToast.showAttachedWidget(
      attachedBuilder: (_) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4.0),
            ),
            height: 86,
            child: Column(
              children: [
                ImageIcon(
                  imageProvider ??
                      Assets.images.common.iconToastSuccess.image().image,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
      onlyOne: true,
      duration: const Duration(seconds: 2),
      target: Offset(Get.width / 2, Get.height / 2),
      onClose: onClose);
}
