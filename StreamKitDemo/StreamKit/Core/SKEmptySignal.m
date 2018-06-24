//
//  SKEmptySignal.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKEmptySignal.h"
#import "SKCompoundDisposable.h"
#import "SKSubscriber.h"
#import "SKScheduler.h"

@implementation SKEmptySignal

+ (instancetype)empty {
    return [SKEmptySignal return:nil];
}

- (SKDisposable *)subscribe:(id<SKSubscriber>)subscriber {
    SKCompoundDisposable *disposable = [SKCompoundDisposable disposableWithdisposes:nil];
    SKDisposable *subscriberDisposable = [SKScheduler.subscriptionScheduler schedule:^{
        [subscriber sendCompleted];
    }];
    [disposable addDisposable:subscriberDisposable];
    return disposable;
}

@end
