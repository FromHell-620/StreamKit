//
//  SKRealSignal.h
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKSignal.h"

@protocol SKSubscriber;
@class SKDisposable;

@interface SKDynamicSignal : SKSignal

+ (instancetype)signalWithBlock:(SKDisposable * (^)(id<SKSubscriber> subscriber))block;

@end
