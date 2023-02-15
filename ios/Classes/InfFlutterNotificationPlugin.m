#import "InfFlutterNotificationPlugin.h"
#if __has_include(<inf_flutter_notification/inf_flutter_notification-Swift.h>)
#import <inf_flutter_notification/inf_flutter_notification-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "inf_flutter_notification-Swift.h"
#endif

@implementation InfFlutterNotificationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInfFlutterNotificationPlugin registerWithRegistrar:registrar];
}
@end
