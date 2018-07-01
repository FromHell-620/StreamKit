//
//  SKErrorSignal.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKErrorSignal.h"
#import "SKCompoundDisposable.h"
#import "SKScheduler.h"
#import "SKSubscriber.h"

@implementation SKErrorSignal

+ (instancetype)error:(NSError *)error {
    return [self return:error];
}

- (SKDisposable *)subscribe:(id<SKSubscriber>)subscriber {
    SKCompoundDisposable *disposable = [SKCompoundDisposable disposableWithdisposes:nil];
    SKDisposable *subscriberDisposable = [SKScheduler.subscriptionScheduler schedule:^{
        [subscriber sendError:self.value];
    }];
    [disposable addDisposable:subscriberDisposable];
    return disposable;
}

@end
