import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import '../utils/date_util.dart';
import 'scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'scrollable_clean_calendar/utils/enums.dart';

class CalendarPicker extends StatefulWidget {
  final String label;
  final CleanCalendarController calendarController;
  final Rx<String> dataValue;
  final DateRange dateRange;
  final ValueChanged<CleanCalendarController> onCalendarConfirmClick;

  const CalendarPicker({
    Key? key,
    required this.label,
    required this.calendarController,
    required this.dataValue,
    required this.dateRange,
    required this.onCalendarConfirmClick,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CalendarPickerState();
  }
}

class _CalendarPickerState extends State<CalendarPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Text(
            widget.label,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        GestureDetector(
          onTap: () => _showCalendarBottomSheet(
              widget.label, widget.calendarController, widget.dateRange),
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final dateString = widget.dataValue.value;
                      return Expanded(
                        child: Text(
                          dateString.isEmpty ? '请选择' : dateString,
                          style: const TextStyle(
                            color: Color(0xFF767676),
                            fontSize: 16,
                          ),
                        ),
                      );
                    }),
                    Assets.images.common.iconArrowForward.image(
                        width: 24, height: 24, color: const Color(0xFF959595)),
                  ],
                ),
              ),
              const Divider(
                  color: Color(0xFFF0F0F0),
                  height: 1,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20),
            ],
          ),
        ),
      ],
    );
  }

  _showCalendarBottomSheet(String label,
      CleanCalendarController calendarController, DateRange dateRange) {
    calendarController.clearSelectedDates();
    calendarController.rangeMinDate = dateRange.from;
    calendarController.rangeMaxDate = dateRange.to;
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildLabelWidget(label),
          _buildScrollableCleanCalendar(calendarController),
          _buildToolBar(calendarController),
        ],
      ),
      backgroundColor: Colors.white,
      barrierColor: const Color(0xB3000000),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      isScrollControlled: true,
    );
  }

  _buildLabelWidget(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: ImageIcon(Assets.images.common.iconClose.image().image),
            iconSize: 24,
            color: const Color(0xFF777777),
          ),
        ],
      ),
    );
  }

  _buildToolBar(CleanCalendarController calendarController) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Color(0xFFF0F0F0),
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(10, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              calendarController.clearSelectedDates();
            },
            style: TextButton.styleFrom(padding: const EdgeInsets.all(10)),
            child: const Text(
              '重置',
              style: TextStyle(
                  color: Color(0xFF767676),
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onCalendarConfirmClick(widget.calendarController);
              Get.back();
            },
            style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.5, horizontal: 63),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: const Color(0xFFFF9F08)),
            child: const Text(
              '确定',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  _buildScrollableCleanCalendar(CleanCalendarController calendarController) {
    return ScrollableCleanCalendar(
      locale: 'zh',
      calendarController: calendarController,
      layout: Layout.BEAUTY,
      monthTextAlign: TextAlign.start,
      monthTextStyle: const TextStyle(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
      weekdayTextStyle: const TextStyle(
          color: Color(0xFF434343), fontSize: 14, fontWeight: FontWeight.w400),
      daySelectedBackgroundColor: const Color(0xFFFFA20C),
      daySelectedBackgroundColorBetween: const Color(0xFFFFEBCE),
      dayTextStyle: const TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
      dayDisableBackgroundColor: const Color(0xFFAAAAAA),
      spaceBetweenCalendars: 20,
      spaceBetweenMonthAndCalendar: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
