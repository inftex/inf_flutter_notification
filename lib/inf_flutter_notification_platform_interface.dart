import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'inf_flutter_notification_method_channel.dart';

abstract class InfFlutterNotificationPlatform extends PlatformInterface {
  /// Constructs a InfFlutterNotificationPlatform.
  InfFlutterNotificationPlatform() : super(token: _token);

  static final Object _token = Object();

  static InfFlutterNotificationPlatform _instance = MethodChannelInfFlutterNotification();

  /// The default instance of [InfFlutterNotificationPlatform] to use.
  ///
  /// Defaults to [MethodChannelInfFlutterNotification].
  static InfFlutterNotificationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [InfFlutterNotificationPlatform] when
  /// they register themselves.
  static set instance(InfFlutterNotificationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
