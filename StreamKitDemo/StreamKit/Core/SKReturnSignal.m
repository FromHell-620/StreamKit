//
//  SKRetureSignal.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKReturnSignal.h"
#import "SKCompoundDisposable.h"
#import "SKScheduler.h"
#import "SKSubscriber.h"

@interface SKReturnSignal ()

/**
 This value will be send when subscriber's nextblock call.
 */
@property (nonatomic,strong,readwrite) id value;

@end

@implementation SKReturnSignal

+ (instancetype)return:(id)value {
    SKReturnSignal *signal = [self new];
    signal.value = value;
    return signal;
}

- (SKDisposable *)subscribe:(id<SKSubscriber>)subscriber {
    NSCParameterAssert(subscriber);
    SKCompoundDisposable *disposable = [SKCompoundDisposable disposableWithBlock:nil];
    [disposable addDisposable:[[SKScheduler subscriptionScheduler] schedule:^{
        [subscriber sendNext:self.value];
        [subscriber sendCompleted];
    }]];
    return disposable;
}

@end
