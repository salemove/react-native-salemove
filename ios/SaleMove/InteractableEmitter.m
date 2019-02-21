#import "InteractableEmmiter.h"

@implementation InteractableEmmiter

RCT_EXPORT_MODULE(InteractableEmmiter);

- (NSArray<NSString *> *)supportedEvents {
    return @[
             @"message_received",
             @"engagement_start",
             @"engagement_end",
             @"audio_stream_add",
             @"video_stream_add"
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
