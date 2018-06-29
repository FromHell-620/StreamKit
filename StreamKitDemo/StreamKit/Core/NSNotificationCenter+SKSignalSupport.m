//
//  NSNotificationCenter+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/7/8.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "NSNotificationCenter+SKSignalSupport.h"
#import "SKObjectifyMarco.h"
#import "SKSignal.h"
#import "SKSubscriber.h"
#import "SKDisposable.h"
#import "SKCompoundDisposable.h"
#import "NSObject+SKDeallocating.h"

@implementation NSNotificationCenter (SKSignalSupport)

- (SKSignal *)sk_signalWithName:(NSNotificationName)name object:(id)object {
    return [self sk_signalWithName:name object:object observer:nil];
}

- (SKSignal *)sk_signalWithName:(NSNotificationName)name object:(id)object observer:(id)observer {
    @weakify(self)
    __unsafe_unretained NSObject *observer_ = observer;
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        @strongify(self)
        id notificationObserver = [self addObserverForName:name object:object queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [subscriber sendNext:note];
        }];
        SKDisposable *removeDisposable = [SKDisposable disposableWithBlock:^{
            [self removeObserver:notificationObserver];
        }];
        [observer_.deallocDisposable addDisposable:removeDisposable];
        return [SKDisposable disposableWithBlock:^{
            [removeDisposable dispose];
            [observer_.deallocDisposable removeDisposable:removeDisposable];
        }];
    }];
}

@end
