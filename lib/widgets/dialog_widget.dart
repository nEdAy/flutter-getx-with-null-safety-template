import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'button_widget.dart';

class DialogWidget extends Dialog {
  @override
  Widget? get child => _buildDialogWidget();

  @override
  EdgeInsets? get insetPadding => const EdgeInsets.symmetric(horizontal: 20);

  final String titleText;
  final AlignmentGeometry titleAlignment;
  final Widget? contentWidget;
  final String negativeButtonText;
  final String positiveButtonText;
  final int positiveButtonTextColor;
  final int positiveButtonBackgroundColor;
  final int positiveButtonSideColor;
  final GestureTapCallback? onNegativeButtonTextPressed;
  final GestureTapCallback onPositiveButtonPressed;

  const DialogWidget({
    super.key,
    required this.titleText,
    this.titleAlignment = Alignment.center,
    this.contentWidget,
    this.negativeButtonText = '取消',
    this.positiveButtonText = '确认提交',
    this.positiveButtonTextColor = 0xFF000000,
    this.positiveButtonBackgroundColor = 0xFFFF9F08,
    this.positiveButtonSideColor = 0xFFFF9F08,
    this.onNegativeButtonTextPressed,
    required this.onPositiveButtonPressed,
  });

  _buildDialogWidget() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 1.sh * 0.75,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  alignment: titleAlignment,
                  child: Text(
                    titleText,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                contentWidget ?? const SizedBox.shrink(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        negativeButtonText,
                        0xFF000000,
                        18,
                        FontWeight.normal,
                        0,
                        12.5,
                        0xFFFFFFFF,
                        sideColor: 0xE6E6E6E6,
                        sideWidth: 1,
                        borderRadius: 6,
                        onPressed: () {
                          Get.back();
                          onNegativeButtonTextPressed?.call();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ButtonWidget(
                        positiveButtonText,
                        positiveButtonTextColor,
                        18,
                        FontWeight.bold,
                        0,
                        12.5,
                        positiveButtonBackgroundColor,
                        sideColor: positiveButtonSideColor,
                        sideWidth: 0,
                        borderRadius: 6,
                        onPressed: () {
                          Get.back();
                          onPositiveButtonPressed();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
