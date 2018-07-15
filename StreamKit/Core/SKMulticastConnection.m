//
//  SKMulticastConection.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/7/4.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKMulticastConnection.h"
#import "SKMulticastConnection+Private.h"
#import <libkern/OSAtomic.h>
#import "SKSignal.h"
#import "SKSerialDisposable.h"

@implementation SKMulticastConnection {
    SKSignal *_sourceSignal;
    SKSerialDisposable *_serialDisposable;
    int32_t volatile _hasConnected;
}


- (instancetype)initWithSourceSignal:(SKSignal *)sourceSignal subject:(SKSubject *)subject {
    self = [super init];
    if (self) {
        _sourceSignal = sourceSignal;
        _signal = (SKSignal *)subject;
        _serialDisposable = [SKSerialDisposable new];
    }
    return self;
}

- (SKDisposable *)connect {
    BOOL shouldConnect = OSAtomicCompareAndSwap32Barrier(0, 1, &_hasConnected);
    if (shouldConnect)  _serialDisposable.disposable = [_sourceSignal subscribe:(id<SKSubscriber>)_signal];
    return _serialDisposable;
}

- (SKSignal *)autoConnect {
    __block int32_t volatile subscriberCount = 0;
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        OSAtomicIncrement32Barrier(&subscriberCount);
        SKDisposable *subscriberDisposable = [self.signal subscribe:subscriber];
        SKDisposable *connectionDisposable = [self connect];
        return [SKDisposable disposableWithBlock:^{
            [subscriberDisposable dispose];
            if (OSAtomicDecrement32Barrier(&subscriberCount) == 0) {
                [connectionDisposable dispose];
            }
        }];
    }];
}

@end
