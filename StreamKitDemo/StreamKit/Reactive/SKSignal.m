//
//  SKSignal.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/31.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSignal.h"
#import "SKSubscriber.h"

@implementation SKSignal {
    void(^_block)(id<SKSubscriber> subscriber);
}

+ (instancetype)signalWithBlock:(void(^)(id<SKSubscriber> subscriber))block
{
    SKSignal* signal = [SKSignal new];
    signal->_block = [block copy];
    return signal;
}

- (void)subscribe:(void(^)(id x))send
{
    SKSubscriber* subscriber = [SKSubscriber subscriberWithMessage:send];
    !_block?:_block(subscriber);
}

@end

@implementation SKSignal (operation)

- (SKSignal*)concat:(void(^)(id<SKSubscriber> subscriber))block
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
            [self subscribe:^(id x) {
                [subscriber sendMessage:x];
            }];
        }];
}

- (SKSignal*)map:(id(^)(id x))block
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribe:^(id x) {
            [subscriber sendMessage:block(x)];
        }];
    }];
}

@end
