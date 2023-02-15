import 'package:flutter_test/flutter_test.dart';
import 'package:inf_flutter_notification/inf_flutter_notification.dart';
import 'package:inf_flutter_notification/inf_flutter_notification_platform_interface.dart';
import 'package:inf_flutter_notification/inf_flutter_notification_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockInfFlutterNotificationPlatform
    with MockPlatformInterfaceMixin
    implements InfFlutterNotificationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final InfFlutterNotificationPlatform initialPlatform = InfFlutterNotificationPlatform.instance;

  test('$MethodChannelInfFlutterNotification is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelInfFlutterNotification>());
  });

  test('getPlatformVersion', () async {
    InfFlutterNotification infFlutterNotificationPlugin = InfFlutterNotification();
    MockInfFlutterNotificationPlatform fakePlatform = MockInfFlutterNotificationPlatform();
    InfFlutterNotificationPlatform.instance = fakePlatform;

    expect(await infFlutterNotificationPlugin.getPlatformVersion(), '42');
  });
}
