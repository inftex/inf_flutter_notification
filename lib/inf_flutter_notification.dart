import 'inf_flutter_notification_platform_interface.dart';

class InfFlutterNotification {
  Future<String?> getPlatformVersion() {
    return InfFlutterNotificationPlatform.instance.getPlatformVersion();
  }
}
