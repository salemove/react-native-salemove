#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <SalemoveSDK/SalemoveSDK-Swift.h>

@interface InteractableEmmiter: RCTEventEmitter <RCTBridgeModule>
+ (void)emitEventWithName:(NSString *)name andPayload:(NSDictionary *)payload;
@end
