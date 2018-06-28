#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <SalemoveSDK/SalemoveSDK-Swift.h>

typedef void (^VoidCompletitionBlock)(void);
typedef void (^MessageCompletionBlock)(Message * message);

@interface InteractableClient : NSObject <Interactable>
@property (nonatomic, copy) VoidCompletitionBlock startEvent;
@property (nonatomic, copy) VoidCompletitionBlock endEvent;
@property (nonatomic, copy) MessageCompletionBlock operatorMessageEvent;
@end

@interface SaleMove : RCTEventEmitter <RCTBridgeModule>

@end
