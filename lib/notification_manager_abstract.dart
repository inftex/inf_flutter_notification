import 'package:inf_flutter_notification/inf_flutter_notification.dart';

abstract class INotificationManager {
  ///
  /// Initialize
  /// MUST be called on app startup
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
      String? androidChannelId,
      String? androidChannelName,
      String? anndroidChannelDescription,
      bool? iosSound});

  ///
  /// Show notification at HH:mm daily
  ///
  void scheduleDaily({
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
    bool? iosSound,
  });

  void cancel(int id);

  void cancelDaily(int? id);

  ///
  /// Get previous scheduled
  ///
  Future<List<Notification>> getPendingNotifications();
}
