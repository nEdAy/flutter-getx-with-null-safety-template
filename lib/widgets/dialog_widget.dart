import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../gen/assets.gen.dart';
import 'button_widget.dart';

class DialogWidget extends Dialog {
  @override
  Widget? get child => _buildDialogWidget(context);

  @override
  EdgeInsets? get insetPadding => const EdgeInsets.symmetric(horizontal: 20);

  final BuildContext context;
  final String titleText;
  final AlignmentGeometry titleAlignment;
  final TextAlign titleTextAlign;
  final Widget? contentWidget;
  final String negativeButtonText;
  final String positiveButtonText;
  final int positiveButtonTextColor;
  final int positiveButtonBackgroundColor;
  final int positiveButtonSideColor;
  final GestureTapCallback? onNegativeButtonTextPressed;
  final GestureTapCallback? onPositiveButtonPressed;
  final bool noDismiss;
  final bool close;

  const DialogWidget({
    super.key,
    required this.context,
    required this.titleText,
    this.titleAlignment = Alignment.center,
    this.titleTextAlign = TextAlign.start,
    this.contentWidget,
    this.negativeButtonText = '取消',
    this.positiveButtonText = '确认提交',
    this.positiveButtonTextColor = 0xFF000000,
    this.positiveButtonBackgroundColor = 0xFFFF9F08,
    this.positiveButtonSideColor = 0xFFFF9F08,
    this.noDismiss = false,
    this.close = false,
    this.onNegativeButtonTextPressed,
    this.onPositiveButtonPressed,
  });

  ConstrainedBox _buildDialogWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 1.sh * 0.75),
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
                close
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            // height: 60,
                            alignment: Alignment.center,
                            child: Text(
                              titleText,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: contentWidget == null ? 20 : 22,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: ImageIcon(
                              Assets.images.common.iconClose.image().image,
                            ),
                            iconSize: 24,
                          ),
                        ],
                      )
                    : Container(
                        // height: 60,
                        alignment: titleAlignment,
                        child: Text(
                          titleText,
                          textAlign: titleTextAlign,
                          style: TextStyle(
                            fontSize: contentWidget == null ? 20 : 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),
                contentWidget ?? const SizedBox.shrink(),
                close ? const SizedBox.shrink() : const SizedBox(height: 20),
                close
                    ? const SizedBox.shrink()
                    : Row(
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
                                context.pop();
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
                                if (!noDismiss) {
                                  context.pop();
                                }
                                onPositiveButtonPressed?.call();
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
