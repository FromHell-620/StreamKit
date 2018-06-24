//
//  SKRealSignal.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKDynamicSignal.h"
#import "SKScheduler.h"
#import "SKPassthroughSubscriber.h"
#import "SKCompoundDisposable.h"

@interface SKDynamicSignal ()

@property (nonatomic,copy) SKDisposable *(^subscriberBlock)(id<SKSubscriber> subscriber);

@end

@implementation SKDynamicSignal

+ (instancetype)signalWithBlock:(SKDisposable * (^)(id<SKSubscriber> subscriber))block {
    SKDynamicSignal *signal = [SKDynamicSignal new];
    signal.subscriberBlock = block;
    return signal;
}

- (SKDisposable *)subscribe:(id<SKSubscriber>)subscriber {
    SKCompoundDisposable *disposable = [SKCompoundDisposable disposableWithBlock:nil];
    SKPassthroughSubscriber *passthroughSubscriber = [[SKPassthroughSubscriber alloc] initWithSubscriber:subscriber disposable:disposable];
    if (self.subscriberBlock) {
        SKDisposable *schedulerDisposable = [[SKScheduler subscriptionScheduler] schedule:^{
            SKDisposable *selfDisposabel = self.subscriberBlock(passthroughSubscriber);
            [disposable addDisposable:selfDisposabel];
        }];
        [disposable addDisposable:schedulerDisposable];
    }
    return disposable;
}

@end
