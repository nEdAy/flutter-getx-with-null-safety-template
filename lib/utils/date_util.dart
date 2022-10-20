// ignore_for_file: require_trailing_commas

import 'package:intl/intl.dart';
import 'package:quiver/time.dart';

class DateRange {
  DateTime? from;
  DateTime? to;

  DateRange({this.from, this.to});
}

/// 一些常用格式参照。可以自定义格式，例如：'yyyy/MM/dd HH:mm:ss'，'yyyy/M/d HH:mm:ss'。
/// 格式要求
/// year -> yyyy/yy   month -> MM/M    day -> dd/d
/// hour -> HH/H      minute -> mm/m   second -> ss/s
class DateFormats {
  static const String full = 'yyyy-MM-dd HH:mm:ss';
  static const String y_mo_d_h_m = 'yyyy-MM-dd HH:mm';
  static const String y_mo_d = 'yyyy-MM-dd';
  static const String y_mo = 'yyyy-MM';
  static const String mo_d = 'MM-dd';
  static const String mo_d_h_m = 'MM-dd HH:mm';
  static const String h_m_s = 'HH:mm:ss';
  static const String h_m = 'HH:mm';

  static const String zh_full = 'yyyy年MM月dd日 HH时mm分ss秒';
  static const String zh_y_mo_d_h_m = 'yyyy年MM月dd日 HH时mm分';
  static const String zh_y_mo_d = 'yyyy年MM月dd日';
  static const String zh_y_mo = 'yyyy年MM月';
  static const String zh_mo_d = 'MM月dd日';
  static const String zh_mo_d_h_m = 'MM月dd日 HH时mm分';
  static const String zh_h_m_s = 'HH时mm分ss秒';
  static const String zh_h_m = 'HH时mm分';
}

class DateStrOption {
  static const String today = '今天';
  static const String tomorrow = '明天';
  static const String thisWeek = '本周';
  static const String thisMonth = '本月';
}

/// month->days.
const Map<int, int> MONTH_DAY = {
  1: 31,
  2: 28,
  3: 31,
  4: 30,
  5: 31,
  6: 30,
  7: 31,
  8: 31,
  9: 30,
  10: 31,
  11: 30,
  12: 31,
};

/// Date Util.
class DateUtil {
  /// get DateTime By DateStr.
  static DateTime? getDateTime(String dateStr, {bool? isUtc}) {
    DateTime? dateTime = DateTime.tryParse(dateStr);
    if (isUtc != null) {
      if (isUtc) {
        dateTime = dateTime?.toUtc();
      } else {
        dateTime = dateTime?.toLocal();
      }
    }
    return dateTime;
  }

  /// get DateTime By Milliseconds.
  static DateTime getDateTimeByMs(int ms, {bool isUtc = false}) {
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
  }

  /// get DateMilliseconds By DateStr.
  static int? getDateMsByTimeStr(String dateStr, {bool? isUtc}) {
    final dateTime = getDateTime(dateStr, isUtc: isUtc);
    return dateTime?.millisecondsSinceEpoch;
  }

  /// get Now Date Milliseconds.
  static int getNowDateMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// get Now Date Str.(yyyy-MM-dd HH:mm:ss)
  static String getNowDateStr() {
    return formatDate(DateTime.now());
  }

  /// format date by milliseconds.
  /// milliseconds 日期毫秒
  static String formatDateMs(int ms, {bool isUtc = false, String? format}) {
    return formatDate(getDateTimeByMs(ms, isUtc: isUtc), format: format);
  }

  /// format date by date str.
  /// dateStr 日期字符串
  static String formatDateStr(String dateStr, {bool? isUtc, String? format}) {
    return formatDate(getDateTime(dateStr, isUtc: isUtc), format: format);
  }

  /// format date by DateTime.
  /// format 转换格式(已提供常用格式 DateFormats，可以自定义格式：'yyyy/MM/dd HH:mm:ss')
  /// 格式要求
  /// year -> yyyy/yy   month -> MM/M    day -> dd/d
  /// hour -> HH/H      minute -> mm/m   second -> ss/s
  static String formatDate(DateTime? dateTime, {String? format}) {
    if (dateTime == null) return '';
    format = format ?? DateFormats.full;
    if (format.contains('yy')) {
      final String year = dateTime.year.toString();
      if (format.contains('yyyy')) {
        format = format.replaceAll('yyyy', year);
      } else {
        format = format.replaceAll(
            'yy', year.substring(year.length - 2, year.length));
      }
    }

    format = _comFormat(dateTime.month, format, 'M', 'MM');
    format = _comFormat(dateTime.day, format, 'd', 'dd');
    format = _comFormat(dateTime.hour, format, 'H', 'HH');
    format = _comFormat(dateTime.minute, format, 'm', 'mm');
    format = _comFormat(dateTime.second, format, 's', 'ss');
    format = _comFormat(dateTime.millisecond, format, 'S', 'SSS');

    return format;
  }

  /// com format.
  static String _comFormat(
      int value, String format, String single, String full) {
    if (format.contains(single)) {
      if (format.contains(full)) {
        format =
            format.replaceAll(full, value < 10 ? '0$value' : value.toString());
      } else {
        format = format.replaceAll(single, value.toString());
      }
    }
    return format;
  }

  /// get WeekDay.
  /// dateTime
  /// isUtc
  /// languageCode zh or en
  /// short
  static String getWeekday(DateTime? dateTime,
      {String languageCode = 'en', bool short = false}) {
    if (dateTime == null) return '';
    String weekday = '';
    switch (dateTime.weekday) {
      case 1:
        weekday = languageCode == 'zh' ? '星期一' : 'Monday';
        break;
      case 2:
        weekday = languageCode == 'zh' ? '星期二' : 'Tuesday';
        break;
      case 3:
        weekday = languageCode == 'zh' ? '星期三' : 'Wednesday';
        break;
      case 4:
        weekday = languageCode == 'zh' ? '星期四' : 'Thursday';
        break;
      case 5:
        weekday = languageCode == 'zh' ? '星期五' : 'Friday';
        break;
      case 6:
        weekday = languageCode == 'zh' ? '星期六' : 'Saturday';
        break;
      case 7:
        weekday = languageCode == 'zh' ? '星期日' : 'Sunday';
        break;
      default:
        break;
    }
    return languageCode == 'zh'
        ? (short ? weekday.replaceAll('星期', '周') : weekday)
        : weekday.substring(0, short ? 3 : weekday.length);
  }

  /// get WeekDay By Milliseconds.
  static String getWeekdayByMs(int milliseconds,
      {bool isUtc = false, String languageCode = 'en', bool short = false}) {
    final DateTime dateTime = getDateTimeByMs(milliseconds, isUtc: isUtc);
    return getWeekday(dateTime, languageCode: languageCode, short: short);
  }

  /// get day of year.
  /// 在今年的第几天.
  static int getDayOfYear(DateTime dateTime) {
    final int year = dateTime.year;
    final int month = dateTime.month;
    int days = dateTime.day;
    for (int i = 1; i < month; i++) {
      days = days + MONTH_DAY[i]!;
    }
    if (isLeapYearByYear(year) && month > 2) {
      days = days + 1;
    }
    return days;
  }

  /// get day of year.
  /// 在今年的第几天.
  static int getDayOfYearByMs(int ms, {bool isUtc = false}) {
    return getDayOfYear(DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc));
  }

  /// is today.
  /// 是否是当天.
  static bool isToday(int? milliseconds, {bool isUtc = false, int? locMs}) {
    if (milliseconds == null || milliseconds == 0) return false;
    final DateTime old =
        DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime now;
    if (locMs != null) {
      now = DateUtil.getDateTimeByMs(locMs);
    } else {
      now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }
    return old.year == now.year && old.month == now.month && old.day == now.day;
  }

  /// is yesterday by dateTime.
  /// 是否是昨天.
  static bool isYesterday(DateTime dateTime, DateTime locDateTime) {
    if (yearIsEqual(dateTime, locDateTime)) {
      final int spDay = getDayOfYear(locDateTime) - getDayOfYear(dateTime);
      return spDay == 1;
    } else {
      return ((locDateTime.year - dateTime.year == 1) &&
          dateTime.month == 12 &&
          locDateTime.month == 1 &&
          dateTime.day == 31 &&
          locDateTime.day == 1);
    }
  }

  /// is yesterday by millis.
  /// 是否是昨天.
  static bool isYesterdayByMs(int ms, int locMs) {
    return isYesterday(DateTime.fromMillisecondsSinceEpoch(ms),
        DateTime.fromMillisecondsSinceEpoch(locMs));
  }

  /// is Week.
  /// 是否是本周.
  static bool isWeek(int? ms, {bool isUtc = false, int? locMs}) {
    if (ms == null || ms <= 0) {
      return false;
    }
    final DateTime tempOld =
        DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
    DateTime tempNow;
    if (locMs != null) {
      tempNow = DateUtil.getDateTimeByMs(locMs, isUtc: isUtc);
    } else {
      tempNow = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }

    final DateTime old =
        tempNow.millisecondsSinceEpoch > tempOld.millisecondsSinceEpoch
            ? tempOld
            : tempNow;
    final DateTime now =
        tempNow.millisecondsSinceEpoch > tempOld.millisecondsSinceEpoch
            ? tempNow
            : tempOld;
    return (now.weekday >= old.weekday) &&
        (now.millisecondsSinceEpoch - old.millisecondsSinceEpoch <=
            7 * 24 * 60 * 60 * 1000);
  }

  /// year is equal.
  /// 是否同年.
  static bool yearIsEqual(DateTime dateTime, DateTime locDateTime) {
    return dateTime.year == locDateTime.year;
  }

  /// year is equal.
  /// 是否同年.
  static bool yearIsEqualByMs(int ms, int locMs) {
    return yearIsEqual(DateTime.fromMillisecondsSinceEpoch(ms),
        DateTime.fromMillisecondsSinceEpoch(locMs));
  }

  /// Return whether it is leap year.
  /// 是否是闰年
  static bool isLeapYear(DateTime dateTime) {
    return isLeapYearByYear(dateTime.year);
  }

  /// Return whether it is leap year.
  /// 是否是闰年
  static bool isLeapYearByYear(int year) {
    return year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
  }

  /// dateStr: DateStrOption
  /// rangeDate: 能够选中的时间范围 可选参数
  /// transformDateWith("今天") => [DateTime.now()]
  static List<DateTime>? transformDateWith(String dateStr,
      [List<DateTime>? rangeDate]) {
    final todayDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (rangeDate == null || rangeDate.length != 2) {
      if (dateStr == DateStrOption.today) {
        return [todayDate];
      } else if (dateStr == DateStrOption.tomorrow) {
        return [todayDate.add(const Duration(days: 1))];
      } else if (dateStr == DateStrOption.thisWeek) {
        final week = todayDate.weekday;
        DateTime startDate, endDate;
        startDate = todayDate.add(Duration(days: -week + 1));
        endDate = todayDate.add(Duration(days: 7 - week));
        return [startDate, endDate];
      } else if (dateStr == DateStrOption.thisMonth) {
        final day = todayDate.day;
        DateTime startDate, endDate;
        final daysCount = daysInMonth(todayDate.year, todayDate.month);
        startDate = todayDate.add(Duration(days: -day + 1));
        endDate = todayDate.add(Duration(days: daysCount - day));
        return [startDate, endDate];
      }
    } else {
      final limitStartDate =
          DateTime(rangeDate[0].year, rangeDate[0].month, rangeDate[0].day);
      final limitEndDate =
          DateTime(rangeDate[1].year, rangeDate[1].month, rangeDate[1].day);

      if (dateStr == DateStrOption.today) {
        if (todayDate.difference(limitEndDate).inDays > 0) {
          return null;
        }

        if (limitStartDate.difference(todayDate).inDays > 0) {
          return null;
        }

        return [todayDate];
      } else if (dateStr == DateStrOption.tomorrow) {
        final tomorrow = todayDate.add(const Duration(days: 1));

        if (tomorrow.difference(limitEndDate).inDays > 0) {
          return null;
        }

        if (limitStartDate.difference(tomorrow).inDays > 0) {
          return null;
        }
        return [tomorrow];
      } else if (dateStr == DateStrOption.thisWeek) {
        final week = todayDate.weekday;
        final weekStartDate = todayDate.add(Duration(days: -week + 1));
        final weekEndDate = todayDate.add(Duration(days: 7 - week));

        DateTime startDate, endDate;

        if (weekStartDate.difference(limitEndDate).inDays > 0) {
          return null;
        }

        if (limitStartDate.difference(weekEndDate).inDays > 0) {
          return null;
        }

        if (limitStartDate.difference(weekStartDate).inDays > 0) {
          startDate = limitStartDate;
        } else {
          startDate = weekStartDate;
        }

        if (limitEndDate.difference(weekEndDate).inDays <= 0) {
          endDate = limitEndDate;
        } else {
          endDate = weekEndDate;
        }

        return [startDate, endDate];
      } else if (dateStr == DateStrOption.thisMonth) {
        final day = todayDate.day;
        final daysCount = daysInMonth(todayDate.year, todayDate.month);
        final monthStartDate = todayDate.add(Duration(days: -day + 1));
        final monthEndDate = todayDate.add(Duration(days: daysCount - day));
        DateTime startDate, endDate;

        if (monthStartDate.difference(limitEndDate).inDays > 0) {
          return null;
        }

        if (limitStartDate.difference(monthEndDate).inDays > 0) {
          return null;
        }

        if (limitStartDate.difference(monthStartDate).inDays > 0) {
          startDate = limitStartDate;
        } else {
          startDate = monthStartDate;
        }

        if (limitEndDate.difference(monthEndDate).inDays <= 0) {
          endDate = limitEndDate;
        } else {
          endDate = monthEndDate;
        }

        return [startDate, endDate];
      }
    }

    return null;
  }

  /// 转换时间为字符串 今天、明天、本周、本月
  static String transformDateToStrWith(List<DateTime> dateArray,
      [List<DateTime>? rangeDate]) {
    final todayDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (dateArray.length == 1) {
      final date =
          DateTime(dateArray[0].year, dateArray[0].month, dateArray[0].day);
      if (date.difference(todayDate).inDays == 0) {
        final resultArray = transformDateWith(DateStrOption.today, rangeDate);
        if (resultArray != null && resultArray.length == 1) {
          return DateStrOption.today;
        }
      }
      if (date.difference(todayDate).inDays == 1) {
        final resultArray =
            transformDateWith(DateStrOption.tomorrow, rangeDate);
        if (resultArray != null && resultArray.length == 1) {
          return DateStrOption.tomorrow;
        }
      }

      if (date.year != todayDate.year) {
        return '${date.year}.${date.month}.${date.day}';
      } else {
        return '${date.month}.${date.day}';
      }
    } else if (dateArray.length == 2) {
      final startDate =
          DateTime(dateArray[0].year, dateArray[0].month, dateArray[0].day);
      final endDate =
          DateTime(dateArray[1].year, dateArray[1].month, dateArray[1].day);
      if (endDate.difference(startDate).inDays == 0) {
        if (endDate.difference(todayDate).inDays == 0) {
          final resultArray = transformDateWith(DateStrOption.today, rangeDate);
          if (resultArray != null && resultArray.length == 1) {
            return DateStrOption.today;
          }
        }
        if (endDate.difference(todayDate).inDays == 1) {
          final resultArray =
              transformDateWith(DateStrOption.tomorrow, rangeDate);
          if (resultArray != null && resultArray.length == 1) {
            return DateStrOption.tomorrow;
          }
        }

        if (endDate.year != todayDate.year) {
          return '${endDate.year}.${endDate.month}.${endDate.day}';
        } else {
          return '${endDate.month}.${endDate.day}';
        }
      } else {
        final weekResultArray =
            transformDateWith(DateStrOption.thisWeek, rangeDate);
        if (weekResultArray != null && weekResultArray.length == 2) {
          final weekStartDate = DateTime(weekResultArray[0].year,
              weekResultArray[0].month, weekResultArray[0].day);
          final weekEndDate = DateTime(weekResultArray[1].year,
              weekResultArray[1].month, weekResultArray[1].day);

          if (weekStartDate.difference(startDate).inDays == 0 &&
              weekEndDate.difference(endDate).inDays == 0) {
            return DateStrOption.thisWeek;
          }
        }

        final monthResultArray =
            transformDateWith(DateStrOption.thisMonth, rangeDate);
        if (monthResultArray != null && monthResultArray.length == 2) {
          final monthStartDate = DateTime(monthResultArray[0].year,
              monthResultArray[0].month, monthResultArray[0].day);
          final monthEndDate = DateTime(monthResultArray[1].year,
              monthResultArray[1].month, monthResultArray[1].day);

          if (monthStartDate.difference(startDate).inDays == 0 &&
              monthEndDate.difference(endDate).inDays == 0) {
            return DateStrOption.thisMonth;
          }
        }

        var startDateStr = '${startDate.month}.${startDate.day}';
        if (startDate.year != todayDate.year) {
          startDateStr = '${startDate.year}.$startDateStr';
        }

        var endDateStr = '${endDate.month}.${endDate.day}';
        if (endDate.year != todayDate.year) {
          endDateStr = '${endDate.year}.$endDateStr';
        }

        return '$startDateStr-$endDateStr';
      }
    }

    return '';
  }

  static String transformDateStrToFormate(String dateStr,
      {String? dateFormat}) {
    if (dateStr.isEmpty) {
      return '';
    }

    DateFormat formate;

    if (dateFormat != null && dateFormat.isNotEmpty) {
      formate = DateFormat(dateFormat);
    } else {
      formate = DateFormat(DateFormats.full);
    }

    final DateTime date = formate.parse(dateStr);
    final DateFormat timeFormat = DateFormat('HH:mm');
    // 时间字符串
    final timeStr = timeFormat.format(date);

    final formateDate = DateTime(date.year, date.month, date.day);
    final formateToday =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    // final formateTomorrow = DateTime(DateTime.now().add(Duration(days: 1)).year, DateTime.now().add(Duration(days: 1)).month, DateTime.now().add(Duration(days: 1)).day);

    //日期字符串
    var dayStr = '';

    if (formateDate.year == formateToday.year) {
      if (formateDate.difference(formateToday).inDays <= 6) {
        dayStr = transformToFormatWeekStr(formateDate);
      } else if (formateDate.difference(formateToday).inDays == 1) {
        dayStr = '明天';
      } else if (formateDate.difference(formateToday).inDays == 0) {
        dayStr = '今天';
      }
    } else {
      final DateFormat tempDateFormat = DateFormat('yy-MM-dd');
      dayStr = tempDateFormat.format(formateDate);
    }

    return '$dayStr $timeStr';
  }

  static String transformToFormatWeekStr(DateTime dateTime) {
    var weekStr = '';

    switch (dateTime.weekday) {
      case 1:
        weekStr = '本周一';
        break;
      case 2:
        weekStr = '本周二';
        break;
      case 3:
        weekStr = '本周三';
        break;
      case 4:
        weekStr = '本周四';
        break;
      case 5:
        weekStr = '本周五';
        break;
      case 6:
        weekStr = '本周六';
        break;
      case 7:
        weekStr = '本周日';
        break;
      default:
        break;
    }
    return '';
  }
}
