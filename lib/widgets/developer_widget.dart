import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template/env/env_switcher.dart';

import '../global.dart';
import '../routes/app_pages.dart';
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
              return !EnvSwitcher.isDevelopment() && !kDebugMode
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
          OverlayEntry(builder: (context) => const WatermarkWidget()),
        ],
      ),
    );
  }

  Widget _developerWidget() {
    return FloatingActionButton(
      onPressed: () {
        BotToast.closeAllLoading();
        // Navigator.of(navigatorGlobalKey.currentContext!).push(
        //     MaterialPageRoute(
        //       builder: (context) => HttpLogListWidget(),
        //     )
        // );
        Navigator.of(navigatorGlobalKey.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => TalkerScreen(talker: talker),
            )
        );
      },
      tooltip: 'Dio Log',
      child: const Icon(Icons.wifi),
    );
  }
}
