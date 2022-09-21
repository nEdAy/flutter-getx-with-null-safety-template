import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/enums.dart';
import '../utils/extensions.dart';

class MonthWidget extends StatelessWidget {
  final DateTime month;
  final String locale;
  final Layout? layout;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final Widget Function(BuildContext context, String month)? monthBuilder;

  const MonthWidget({
    Key? key,
    required this.month,
    required this.locale,
    required this.layout,
    required this.monthBuilder,
    required this.textStyle,
    required this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text =
        '${DateFormat('yyyy', locale).format(DateTime(month.year, month.month))}年${DateFormat('MMM', locale).format(DateTime(month.year, month.month)).capitalize()}';
    if (monthBuilder != null) {
      return monthBuilder!(context, text);
    }
    return <Layout, Widget Function()>{
      Layout.DEFAULT: () => _pattern(context, text),
      Layout.BEAUTY: () => _beauty(context, text)
    }[layout]!();
  }

  Widget _pattern(BuildContext context, String text) {
    return Text(
      text.capitalize(),
      textAlign: textAlign ?? TextAlign.center,
      style: textStyle ?? Theme.of(context).textTheme.headline6!,
    );
  }

  Widget _beauty(BuildContext context, String text) {
    return Text(
      text.capitalize(),
      textAlign: textAlign ?? TextAlign.center,
      style: textStyle ?? Theme.of(context).textTheme.headline6!,
    );
  }
}
