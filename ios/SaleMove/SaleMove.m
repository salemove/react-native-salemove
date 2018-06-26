//
//  Salemove.m
//  ReactNativeDemo
//
//  Created by Siim Halapuu on 05/03/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SaleMove.h"
#import <SalemoveSDK/SalemoveSDK-Swift.h>

@implementation SaleMove

RCT_EXPORT_MODULE(SaleMove);

RCT_EXPORT_METHOD(sendMessage:(NSString *)messageText callback:(RCTResponseSenderBlock)callback) {
    [Salemove.sharedInstance sendWithMessage:messageText completion:^(Message * _Nullable message, SalemoveError * _Nullable error) {
        id messageError = (error != nil) ? error : [NSNull null];
        id sentMessage = message ? @{
                                     @"id": message.id,
                                     @"content": message.content,
                                     @"sender": @"visitor"
                                     } : [NSNull null];
        
        callback(@[messageError, sentMessage]);
    }];
}

RCT_EXPORT_METHOD(listQueues:(RCTResponseSenderBlock)callback) {
    [Salemove.sharedInstance listQueuesWithCompletion:^(NSArray<Queue *> * _Nullable queues, SalemoveError * _Nullable error) {
        
        id incomingError = (error != nil) ? error : [NSNull null];
        
        id serializedQueues = [NSMutableArray array];
        for (Queue *queue in queues) {
            id serializedQueue = @{@"id": queue.id, @"name": queue.name};
            [serializedQueues addObject:serializedQueue];
        }
        
        callback(@[incomingError, serializedQueues]);
    }];
}

RCT_REMAP_METHOD(requestEngagement,
                 queueID:(NSString *)queueID
                 withResolve:(RCTPromiseResolveBlock)resolve
                 withReject:(RCTPromiseRejectBlock)reject
                 ) {
    
    [Salemove.sharedInstance queueForEngagementWithQueueID:queueID completion:^(QueueTicket * _Nullable queueTicket, SalemoveError * _Nullable error) {
        if (error) {
            reject(@"", error.reason, error.error);
        } else {
            resolve(@"");
        }
    }];
}

RCT_REMAP_METHOD(endEngagement,
                 withResolve:(RCTPromiseResolveBlock)resolve
                 withReject:(RCTPromiseRejectBlock)reject
                 ) {
    
    [Salemove.sharedInstance endEngagementWithCompletion:^(BOOL done, SalemoveError * _Nullable error) {
        if (error) {
            reject(@"", error.reason, error.error);
        } else {
            resolve(@"");
        }
    }];
}
@end
