export 'model/notification.dart';
export 'config/android_schedule_mode.dart';
export 'config/repeat_interval.dart';

export 'notification_manager_abstract.dart';
export 'notification_manager.dart';

import 'inf_flutter_notification_platform_interface.dart';

class InfFlutterNotification {
  Future<String?> getPlatformVersion() {
    return InfFlutterNotificationPlatform.instance.getPlatformVersion();
  }
}
