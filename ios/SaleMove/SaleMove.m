//
//  Salemove.m
//  ReactNativeDemo
//
//  Created by Siim Halapuu on 05/03/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <SalemoveSDK/SalemoveSDK-Swift.h>

@interface RCT_EXTERN_MODULE(SaleMove, NSObject)

RCT_EXTERN_METHOD(sendMessage:(NSString *)messageText callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(listQueues:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(requestEngagement:(NSString *)queueID withResolve:(RCTPromiseResolveBlock)resolve
                  withReject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(updateInformation:(NSString *)name
                  email:(NSString *)email
                  phone:(NSString *)phone
                  externalID:(NSString *)externalID
                  customAttrtibutes:(NSDictionary *)customAttributes
                  withResolve:(RCTPromiseResolveBlock)resolve
                  withReject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(endEngagement:(RCTPromiseResolveBlock)resolve
                  withReject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(requestTwoWayAudio:(RCTPromiseResolveBlock)resolve
                  withReject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(requestTwoWayVideo:(RCTPromiseResolveBlock)resolve
                  withReject:(RCTPromiseRejectBlock)reject)

@end
