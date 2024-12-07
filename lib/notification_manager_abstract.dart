import 'package:inf_flutter_notification/inf_flutter_notification.dart';

abstract class INotificationManager {
  ///
  /// Initialize
  /// MUST be called on app startup
  ///
  /// ANDROID
  /// - Create WHITE and TRANSPARENT [ic_notification] in drawable
  /// - if AndroidScheduleMode.alarmClock/exact/exactAllowWhileIdle
  /// Check https://developer.android.com/develop/background-work/services/alarms/schedule
  /// + For normal app, use this permission, remember to ask runtime permission when sdk > 32
  /// <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" tools:node="merge" />
  ///
  /// + For alarm or calendar app (declare if upload to Google Play), use this permission, no need to check runtime permission
  /// <uses-permission android:name="android.permission.USE_EXACT_ALARM" tools:node="merge" />
  ///
  void setup();

  ///
  /// Normal display
  ///
  void show({
    int? id,
    String? title,
    String? description,
    String? payload,
    String? androidChannelId,
    String? androidChannelName,
    String? anndroidChannelDescription,
    bool? iosSound,
  });

  ///
  /// Schedule at specific date time
  ///
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
      AndroidScheduleMode? androidScheduleMode,
      String? androidChannelId,
      String? androidChannelName,
      String? anndroidChannelDescription,
      bool? iosSound});

  ///
  /// Show notification at HH:mm daily
  /// Read more at schedule()
  ///
  void scheduleDaily({
    required int HH,
    required int mm,
    required int ss,
    int? id,
    String? title,
    String? description,
    AndroidScheduleMode? androidScheduleMode,
    String? payload,
    String? androidChannelId,
    String? androidChannelName,
    String? anndroidChannelDescription,
    bool? iosSound,
  });

  ///
  /// Periodically show a notification with a specified interval
  /// after this function is called
  ///
  void periodicallyShow(
      {int? id,
      String? title,
      String? description,
      String? payload,
      required RepeatInterval repeatInterval,
      AndroidScheduleMode? androidScheduleMode,
      String? androidChannelId,
      String? androidChannelName,
      String? anndroidChannelDescription,
      bool? iosSound});

  void cancel(int id);

  void cancelDaily(int? id);

  ///
  /// Get previous scheduled
  ///
  Future<List<Notification>> getPendingNotifications();
}
