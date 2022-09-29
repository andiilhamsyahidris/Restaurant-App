import 'dart:isolate';
import 'dart:ui';
import 'dart:math' as math;
import 'package:restaurant_app_new/data/api/api_service.dart';
import 'package:restaurant_app_new/data/api/notification_api.dart';
import 'package:restaurant_app_new/main.dart';
import 'package:http/http.dart' as http;

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async {
    final notificationApi = NotificationApi();
    final result = await ApiService(http.Client()).getRestaurants();

    await notificationApi.showNotification(flutterLocalNotificationsPlugin,
        result[math.Random().nextInt(result.length)]);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
