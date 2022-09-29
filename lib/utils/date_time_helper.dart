import 'package:intl/intl.dart';

class DatetimeHelper {
  static DateTime dateTimeScheduled() {
    const timeSpecific = '11:00:00';

    final now = DateTime.now();
    final dateformat = DateFormat('y/M/d');
    final completeFormat = DateFormat('y/M/d H:m:s');

    final todayDate = dateformat.format(now);
    final todayDateAndTime = '$todayDate $timeSpecific';
    final resultToday = completeFormat.parseStrict(todayDateAndTime);
    final formatted = resultToday.add(const Duration(days: 1));
    final tomorrowDate = dateformat.format(formatted);
    final tomorrowDateAndTime = '$tomorrowDate $timeSpecific';
    final resultTomorrow = completeFormat.parseStrict(tomorrowDateAndTime);

    return now.isAfter(resultToday) ? resultTomorrow : resultToday;
  }
}
