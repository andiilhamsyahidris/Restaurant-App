import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app_new/common/result_state.dart';
import 'package:restaurant_app_new/utils/background_service.dart';
import 'package:restaurant_app_new/utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  SchedulingProvider() {
    _getSwitchValue();
  }

  late ResultState _state;
  late bool _isScheduled;

  ResultState get state => _state;
  bool get isScheduled => _isScheduled;

  Future<bool> scheduledRestaurant(bool value) async {
    _isScheduled = value;
    notifyListeners();

    if (_isScheduled) {
      return await AndroidAlarmManager.periodic(
          const Duration(hours: 24), 1, BackgroundService.callback,
          startAt: DatetimeHelper.dateTimeScheduled(),
          exact: true,
          wakeup: true,
          allowWhileIdle: true);
    }
    return await AndroidAlarmManager.cancel(1);
  }

  Future<bool> _getSwitchValue() async {
    _state = ResultState.loading;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('switch_key') == null) {
      await prefs.setBool('switch_key', false);
    }
    _isScheduled = prefs.getBool('switch_key')!;

    _state = ResultState.hasData;
    notifyListeners();

    return _isScheduled;
  }

  Future<void> setSwitchValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switch_key', value);

    _isScheduled = value;
    notifyListeners();
  }
}
