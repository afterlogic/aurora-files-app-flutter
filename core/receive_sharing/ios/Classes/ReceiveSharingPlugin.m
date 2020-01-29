#import "ReceiveSharingPlugin.h"
#if __has_include(<receive_sharing/receive_sharing-Swift.h>)
#import <receive_sharing/receive_sharing-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "receive_sharing-Swift.h"
#endif

@implementation ReceiveSharingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftReceiveSharingPlugin registerWithRegistrar:registrar];
}
@end
