import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_new/data/api/api_service.dart';
import 'package:restaurant_app_new/data/api/notification_api.dart';
import 'package:restaurant_app_new/data/database/favorite_database.dart';
import 'package:restaurant_app_new/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app_new/provider/bottomnav_provider.dart';
import 'package:restaurant_app_new/provider/category_provider.dart';
import 'package:restaurant_app_new/provider/detail_restaurant_provider.dart';
import 'package:restaurant_app_new/provider/favorite_provider.dart';
import 'package:restaurant_app_new/provider/icon_favorite_provider.dart';
import 'package:restaurant_app_new/provider/page_reload_provider.dart';
import 'package:restaurant_app_new/provider/restaurant_provider.dart';
import 'package:restaurant_app_new/provider/scheduling_provider.dart';
import 'package:restaurant_app_new/provider/search_provider.dart';
import 'package:restaurant_app_new/ui/screen/homescreen.dart';
import 'package:restaurant_app_new/ui/theme/color_theme.dart';
import 'package:restaurant_app_new/utils/background_service.dart';
import 'package:http/http.dart' as http;

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: backgroundColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  final notificationsApi = NotificationApi();
  final service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) await AndroidAlarmManager.initialize();

  await notificationsApi.initNotification(flutterLocalNotificationsPlugin);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<BottomNavProvider>(
          create: (_) => BottomNavProvider()),
      ChangeNotifierProvider<SearchProvider>(
        create: (_) => SearchProvider(apiService: ApiService(http.Client())),
      ),
      ChangeNotifierProvider<RestaurantProvider>(
        create: (_) =>
            RestaurantProvider(apiService: ApiService(http.Client())),
      ),
      ChangeNotifierProvider<CategoryProvider>(
        create: (_) => CategoryProvider(),
      ),
      ChangeNotifierProvider<DetailRestaurantProvider>(
        create: (_) =>
            DetailRestaurantProvider(apiService: ApiService(http.Client())),
      ),
      ChangeNotifierProvider<PageReloadProvider>(
        create: (_) => PageReloadProvider(),
      ),
      ChangeNotifierProvider<FavoriteProvider>(
        create: (_) => FavoriteProvider(favoriteDatabase: FavoriteDatabase()),
      ),
      ChangeNotifierProvider<SchedulingProvider>(
        create: (_) => SchedulingProvider(),
      ),
      ChangeNotifierProvider<IconFavoriteProvider>(
          create: (_) =>
              IconFavoriteProvider(favoriteDatabase: FavoriteDatabase()))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            canvasColor: backgroundColor,
            colorScheme: ColorScheme.fromSeed(
                seedColor: primaryColor,
                primary: primaryColor,
                secondary: secondaryColor,
                background: backgroundColor)),
        home: const Homescreen());
  }
}
