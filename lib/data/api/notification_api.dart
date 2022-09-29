import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app_new/data/model/restaurant_model.dart';
import 'package:restaurant_app_new/ui/screen/detailscreen.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationApi {
  static NotificationApi? _notificationApi;

  NotificationApi._internal() {
    _notificationApi = this;
  }
  factory NotificationApi() => _notificationApi ?? NotificationApi._internal();

  Future<void> initNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const initSettingsAndroid = AndroidInitializationSettings('app_icon');
    const initSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);
    const initSettings = InitializationSettings(
        android: initSettingsAndroid, iOS: initSettingsIOS);

    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      selectNotificationSubject.add(details.payload ?? 'empty_payload');
    }

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (payload) async {
      selectNotificationSubject.add(payload ?? 'empty_payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantModel restaurantModel) async {
    const channelId = '1';
    const channelName = 'channel_01';
    const channelDescription = 'restaurant_channel';

    const androidPlatformChannelSpesifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: DefaultStyleInformation(true, true));

    const iOSPlatformChannelSpesifics = IOSNotificationDetails();

    const platformChannelSpesifics = NotificationDetails(
        android: androidPlatformChannelSpesifics,
        iOS: iOSPlatformChannelSpesifics);

    final title = '<b>${restaurantModel.name}</b>';
    const body =
        'Rekomendasi Restaurant Untukmu. Klik untuk melihat Restaurant';

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpesifics,
        payload: jsonEncode(restaurantModel.toMap()));
  }

  void configureSelectNotificationSubject(BuildContext context) {
    selectNotificationSubject.stream.listen((payload) {
      final result = jsonDecode(payload);
      final restaurant = RestaurantModel.fromMap(result);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailScreen(restaurantId: restaurant.id)));
    });
  }
}
