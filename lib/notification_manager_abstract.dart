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
}
