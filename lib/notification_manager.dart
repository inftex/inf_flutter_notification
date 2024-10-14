import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:inf_flutter_notification/inf_flutter_notification.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const idDailyNotification = 1111;

class NotificationManager extends INotificationManager {
  static NotificationManager? _instance;
  NotificationManager._();
  static NotificationManager get instance {
    _instance ??= NotificationManager._();
    return _instance!;
  }

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ///
  /// Setup
  ///
  @override
  void setup() async {
    _configureLocalTimeZone();

    InitializationSettings initializationSettings = InitializationSettings(
        android: _createAndroidInitialConfigs(),
        iOS: _createIosInitialConfigs());
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (_) {});
    debugPrint("setup inftex notification");
  }

  ///
  /// Show noitifcation
  ///
  @override
  void show(
      {int? id,
      String? title,
      String? description,
      String? payload,
      String? androidChannelId,
      String? androidChannelName,
      String? anndroidChannelDescription,
      bool? iosSound}) async {
    NotificationDetails notificationDetails = NotificationDetails(
      android: _createAndroidConfigs(
        androidChannelId: androidChannelId,
        androidChannelName: androidChannelName,
        anndroidChannelDescription: anndroidChannelDescription,
      ),
      iOS: _createIosConfigs(
        iosSound: iosSound,
      ),
    );
    await _flutterLocalNotificationsPlugin.show(
      id ?? 0,
      title,
      description,
      notificationDetails,
      payload: payload,
    );
    debugPrint("show notification $id");
  }

  ///
  /// Schedule at specific
  ///
  @override
  void schedule(
      {required int yyyy,
      required int MM,
      required int dd,
      required int HH,
      required int mm,
      required int ss,
      int? id,
      String? title,
      String? description,
      String? payload,
      String? androidChannelId,
      String? androidChannelName,
      String? anndroidChannelDescription,
      bool? iosSound}) {
    //setup moment
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, yyyy, MM, dd, HH, mm, ss);
    if (scheduleDate.isBefore(now)) {
      debugPrint("can not schedule in-the-past notification $id");
      return;
    }

    _scheduleNotification(
        id: id,
        title: title,
        description: description,
        payload: payload,
        scheduleDate: scheduleDate,
        androidChannelId: androidChannelId,
        androidChannelName: androidChannelName,
        anndroidChannelDescription: anndroidChannelDescription,
        iosSound: iosSound,
        matchMode: DateTimeComponents.dateAndTime);
    debugPrint("schedule notification $id");
  }

  ///
  /// Schedule daily notification
  ///
  @override
  void scheduleDaily(
      {required int HH,
      required int mm,
      required int ss,
      int? id,
      String? title,
      String? description,
      String? payload,
      String? androidChannelId,
      String? androidChannelName,
      String? anndroidChannelDescription,
      bool? iosSound}) {
    //setup moment
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, HH, mm, ss);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    _scheduleNotification(
        id: id,
        title: title,
        description: description,
        payload: payload,
        scheduleDate: scheduleDate,
        androidChannelId: androidChannelId,
        androidChannelName: androidChannelName,
        anndroidChannelDescription: anndroidChannelDescription,
        iosSound: iosSound,
        matchMode: DateTimeComponents.time);
    debugPrint("schedule daily notification $id");
  }

  @override
  void cancel(int id) {
    _flutterLocalNotificationsPlugin.cancel(id);
    debugPrint("cancel notification $id");
  }

  @override
  void cancelDaily(int? id) {
    cancel(id ?? idDailyNotification);
    debugPrint("cancel daily notification $id");
  }

  @override
  Future<List<Notification>> getPendingNotifications() async {
    final list =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return list
        .map((e) => Notification(
            id: e.id, title: e.title, body: e.body, payload: e.payload))
        .toList();
  }

  ///
  /// [matchMode] the condition to fire notification
  ///
  void _scheduleNotification(
      {required int? id,
      required String? title,
      required String? description,
      required String? payload,
      required tz.TZDateTime scheduleDate,
      required String? androidChannelId,
      required String? androidChannelName,
      required String? anndroidChannelDescription,
      required bool? iosSound,
      required DateTimeComponents matchMode}) {
    _flutterLocalNotificationsPlugin.zonedSchedule(
        id ?? idDailyNotification,
        title,
        description,
        scheduleDate,
        NotificationDetails(
            android: _createAndroidConfigs(
              androidChannelId: androidChannelId,
              androidChannelName: androidChannelName,
              anndroidChannelDescription: anndroidChannelDescription,
            ),
            iOS: _createIosConfigs(
              iosSound: iosSound,
            )),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: payload,
        matchDateTimeComponents: matchMode);
  }

  //android
  AndroidInitializationSettings _createAndroidInitialConfigs() {
    return const AndroidInitializationSettings('ic_notification');
  }

  AndroidNotificationDetails _createAndroidConfigs({
    String? androidChannelId,
    String? androidChannelName,
    String? anndroidChannelDescription,
  }) {
    return AndroidNotificationDetails(
      androidChannelId ?? '',
      androidChannelName ?? '',
      channelDescription: anndroidChannelDescription ?? '',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[],
    );
  }

  //ios
  DarwinInitializationSettings _createIosInitialConfigs() {
    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[];
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
      notificationCategories: darwinNotificationCategories,
    );
    return initializationSettingsDarwin;
  }

  DarwinNotificationDetails _createIosConfigs({bool? iosSound}) {
    return DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: iosSound,
    );
  }

  //timezone
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
}
