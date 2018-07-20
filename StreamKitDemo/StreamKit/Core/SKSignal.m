//
//  SKSignal.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/31.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSignal.h"
#import "SKDynamicSignal.h"
#import "SKSubscriber.h"
#import "SKScheduler.h"
#import "SKReturnSignal.h"
#import "SKEmptySignal.h"
#import "SKErrorSignal.h"

@implementation SKSignal

+ (instancetype)signalWithBlock:(SKDisposable *(^)(id<SKSubscriber> subscriber))block {
    return [SKDynamicSignal signalWithBlock:block];
}

+ (instancetype)return:(id)value {
    return [SKReturnSignal return:value];
}

+ (instancetype)error:(NSError *)error {
    return [SKErrorSignal error:error];
}

+ (instancetype)empty {
    return [SKEmptySignal empty];
}

+ (instancetype)nerver {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        return nil;
    }];
}

@end

@implementation SKSignal (Subscriber)

- (SKDisposable *)subscribe:(id<SKSubscriber>)subscriber {
    NSCAssert(NO, @"must be override by subclass");
    return nil;
}

- (SKDisposable *)subscribeNext:(void (^)(id))next {
    SKSubscriber *o = [SKSubscriber subscriberWithNext:next error:nil completed:nil];
    return [self subscribe:o];
}

- (SKDisposable *)subscribeError:(void (^)(NSError *))error {
    SKSubscriber *o = [SKSubscriber subscriberWithNext:nil error:error completed:nil];
    return [self subscribe:o];
}

- (SKDisposable *)subscribeCompleted:(void (^)(void))completed {
    SKSubscriber *o = [SKSubscriber subscriberWithNext:nil error:nil completed:completed];
    return [self subscribe:o];
}

- (SKDisposable *)subscribeNext:(void (^)(id))next error:(void (^)(NSError *))error {
    SKSubscriber *o = [SKSubscriber subscriberWithNext:next error:error completed:nil];
    return [self subscribe:o];
}

- (SKDisposable *)subscribeNext:(void (^)(id))next completed:(void (^)(void))completed {
    SKSubscriber *o = [SKSubscriber subscriberWithNext:next error:nil completed:completed];
    return [self subscribe:o];
}

- (SKDisposable *)subscribeNext:(void (^)(id))next error:(void (^)(NSError *))error completed:(void (^)(void))completed {
    SKSubscriber *o = [SKSubscriber subscriberWithNext:next error:error completed:completed];
    return [self subscribe:o];
}

- (void)subscribeWithReturnValue:(id (^)(id))next {
    [self subscribeWithReturnValue:next complete:nil];
}

- (void)subscribeWithReturnValue:(id (^)(id))next complete:(id (^)(id))complete {
    //not implementation this version
}

@end
