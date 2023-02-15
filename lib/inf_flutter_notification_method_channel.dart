import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'inf_flutter_notification_platform_interface.dart';

/// An implementation of [InfFlutterNotificationPlatform] that uses method channels.
class MethodChannelInfFlutterNotification extends InfFlutterNotificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('inf_flutter_notification');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
