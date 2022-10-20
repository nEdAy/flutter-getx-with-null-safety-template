import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String content;
  final int textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double horizontal;
  final double vertical;
  final int backgroundColor;

  final int sideColor;
  final double sideWidth;
  final double borderRadius;

  final GestureTapCallback onPressed;

  const ButtonWidget(this.content, this.textColor, this.fontSize,
      this.fontWeight, this.horizontal, this.vertical, this.backgroundColor,
      {Key? key,
      this.sideColor = 0xFFFFFFFF,
      this.sideWidth = 0,
      this.borderRadius = 0,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical)),
        backgroundColor: MaterialStateProperty.all(Color(backgroundColor)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius))),
        side: MaterialStateProperty.all(BorderSide(
          color: Color(sideColor),
          width: sideWidth,
        )),
      ),
      child: Text(content,
          strutStyle: StrutStyle(
            fontSize: fontSize,
            leading: 0,
            height: 1.1,
            // 1.1更居中
            forceStrutHeight: true, // 关键属性 强制改为文字高度
          ),
          style: TextStyle(
              color: Color(textColor),
              fontSize: fontSize,
              fontWeight: fontWeight)),
    );
  }
}
