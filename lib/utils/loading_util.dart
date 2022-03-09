import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingUtil {
  static Set dict = {};
  static bool _isShowing = false;

  static void show(
      {BuildContext? context,
      Widget child = const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue)),
      String? tag}) {
    tag ?? dict.add(tag);
    if (!_isShowing) {
      _isShowing = true;
      Get.to(_PopRoute(child: _Progress(child: _Progress(child: child))));
    }
  }

  ///隐藏
  static void dismiss({String? tag}) {
    tag ?? dict.remove(tag);
    if ((tag == null || dict.isEmpty) && _isShowing) {
      Get.back();
      _isShowing = false;
    }
  }
}

///Widget
class _Progress extends StatelessWidget {
  final Widget child;

  const _Progress({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Center(
          child: child,
        ));
  }
}

///Route
class _PopRoute extends PopupRoute {
  final Duration _duration = const Duration(milliseconds: 300);
  Widget child;

  _PopRoute({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
