#import "CryptoPlugin.h"
#import <crypto_plugin/crypto_plugin-Swift.h>

@implementation CryptoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCryptoPlugin registerWithRegistrar:registrar];
}
@end
