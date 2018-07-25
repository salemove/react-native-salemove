#import "InteractableClient.h"

@implementation InteractableEmmiter

RCT_EXPORT_MODULE(InteractableEmmiter);

- (NSArray<NSString *> *)supportedEvents {
    return @[
             @"operator_message",
             @"engagement_start",
             @"engagement_end",
             ];
}

- (void)startObserving {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    for (NSString *notificationName in [self supportedEvents]) {
        [center addObserver:self
                   selector:@selector(emitEventInternal:)
                       name:notificationName
                     object:nil];
    }
}

- (void)emitEventInternal:(NSNotification *)notification {
    [self sendEventWithName:notification.name
                       body:notification.userInfo];
}

+ (void)emitEventWithName:(NSString *)name andPayload:(NSDictionary *)payload {
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:self
                                                      userInfo:payload];
}

- (void)stopObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation InteractableClient
- (void)failWith:(SalemoveError *)error {
    
}

- (void)end {
    [InteractableEmmiter emitEventWithName:@"engagement_end" andPayload:nil];
}

- (void)start {
    [InteractableEmmiter emitEventWithName:@"engagement_start" andPayload:nil];
}

- (void)receiveWithMessage:(Message * _Nonnull)message {
    NSDictionary *payload = @{
                              @"id": message.id,
                              @"content": message.content,
                              @"sender": @"operator"
                              };
    [InteractableEmmiter emitEventWithName:@"operator_message" andPayload:payload];
}

- (void)handleOperatorsWithOperators:(NSArray<Operator *> * _Nonnull)operators {}

@synthesize onMessagesUpdated;
@synthesize onAudioStreamAdded;
@synthesize onMediaUpgradeOffer;
@synthesize onVideoStreamAdded;

@end
