import 'package:flutter/material.dart';

import '../controllers/clean_calendar_controller.dart';
import '../utils/enums.dart';
import '../utils/extensions.dart';

class WeekdaysWidget extends StatelessWidget {

  const WeekdaysWidget({
    super.key,
    required this.showWeekdays,
    required this.cleanCalendarController,
    required this.locale,
    required this.layout,
    required this.weekdayBuilder,
    required this.textStyle,
  });

  final bool showWeekdays;
  final CleanCalendarController cleanCalendarController;
  final String locale;
  final Layout? layout;
  final TextStyle? textStyle;
  final Widget Function(BuildContext context, String weekday)? weekdayBuilder;

  @override
  Widget build(BuildContext context) {
    if (!showWeekdays) return const SizedBox.shrink();
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 44,
      ),
      child: GridView.count(
        crossAxisCount: DateTime.daysPerWeek,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: List.generate(DateTime.daysPerWeek, (index) {
          var weekDay = cleanCalendarController.getDaysOfWeek(locale)[index];
          if (locale == 'zh' && weekDay.length == 2) {
            weekDay = weekDay.substring(1, 2);
          }
          if (weekdayBuilder != null) {
            return weekdayBuilder!(context, weekDay);
          }
          return <Layout, Widget Function()>{
            Layout.DEFAULT: () => _pattern(context, weekDay),
            Layout.BEAUTY: () => _beauty(context, weekDay)
          }[layout]!();
        }),
      ),
    );
  }

  Widget _pattern(BuildContext context, String weekday) {
    return Center(
      child: Text(
        weekday.capitalize(),
        style: textStyle ??
            Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .color!
                      .withOpacity(.4),
                  fontWeight: FontWeight.bold,
                ),
      ),
    );
  }

  Widget _beauty(BuildContext context, String weekday) {
    return Center(
      child: Text(
        weekday.capitalize(),
        style: textStyle ??
            Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .color!
                      .withOpacity(.4),
                  fontWeight: FontWeight.bold,
                ),
      ),
    );
  }
}
