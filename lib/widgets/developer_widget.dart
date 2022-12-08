import 'package:bot_toast/bot_toast.dart';
import 'package:dio_log/http_log_list_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../config/flavor.dart';
import 'watermark_widget.dart';

class DeveloperWidget extends StatefulWidget {
  final Widget? child;

  const DeveloperWidget({super.key, required this.child});

  @override
  State<StatefulWidget> createState() {
    return _DeveloperWidgetState();
  }
}

class _DeveloperWidgetState extends State<DeveloperWidget> {
  Offset offset = Offset(1.sw * 0.8, 1.sh * 0.8);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [
          OverlayEntry(builder: (_) => widget.child ?? const SizedBox.shrink()),
          OverlayEntry(
            builder: (_) {
              return FlavorConfig.isProduction() && !kDebugMode
                  ? const SizedBox.shrink()
                  : Positioned(
                      left: offset.dx,
                      top: offset.dy,
                      child: Draggable(
                        childWhenDragging: Container(),
                        feedback: _developerWidget(),
                        child: _developerWidget(),
                        onDragEnd: (DraggableDetails detail) {
                          setState(() {
                            offset = detail.offset;
                          });
                        },
                      ),
                    );
            },
          ),
          OverlayEntry(
            builder: (context) => const WatermarkWidget(),
          ),
        ],
      ),
    );
  }

  Widget _developerWidget() {
    return FloatingActionButton(
      onPressed: () {
        BotToast.closeAllLoading();
        Get.to(HttpLogListWidget.new);
      },
      tooltip: 'Dio Log',
      backgroundColor: FlavorConfig.instance.color,
      child: const Icon(Icons.wifi),
    );
  }
}
