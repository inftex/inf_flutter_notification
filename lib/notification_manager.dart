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
        matchDateTimeComponents: DateTimeComponents.time);
  }

  @override
  void cancel(int id) {
    _flutterLocalNotificationsPlugin.cancel(id);
  }

  @override
  void cancelDaily(int? id) {
    cancel(id ?? idDailyNotification);
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
