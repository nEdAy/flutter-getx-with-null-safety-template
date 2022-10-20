import 'package:dio_log/http_log_list_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/flavor.dart';

class DeveloperWidget extends StatefulWidget {
  final Widget? child;

  const DeveloperWidget({super.key, required this.child});

  @override
  State<StatefulWidget> createState() {
    return _DeveloperWidgetState();
  }
}

class _DeveloperWidgetState extends State<DeveloperWidget> {
  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.isProduction() && !kDebugMode) {
      return widget.child ?? const SizedBox.shrink();
    }
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [
          OverlayEntry(builder: (_) => widget.child ?? const SizedBox.shrink()),
          OverlayEntry(
            builder: (_) {
              Offset offset = Offset(context.width * 0.8, context.height * 0.8);
              return Positioned(
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
        ],
      ),
    );
  }

  Widget _developerWidget() {
    return FloatingActionButton(
      onPressed: () => Get.to(HttpLogListWidget.new),
      tooltip: 'Dio Log',
      backgroundColor: FlavorConfig.instance.color,
      child: const Icon(Icons.wifi),
    );
  }
}
