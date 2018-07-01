//
//  UIGestureRecognizer+SKSignalSupport.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/23.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "UIGestureRecognizer+SKSignalSupport.h"
#import "SKSignal.h"
#import "SKDisposable.h"
#import "SKCompoundDisposable.h"
#import "SKObjectifyMarco.h"
#import "SKSubscriber.h"
#import "NSObject+SKDeallocating.h"

@implementation UIGestureRecognizer (SKSignalSupport)

- (SKSignal *)sk_eventSignal {
    @unsafeify(self)
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        @strongify(self)
        [self addTarget:subscriber action:@selector(sendNext:)];
        [self.deallocDisposable addDisposable:[SKDisposable disposableWithBlock:^{
            [subscriber sendCompleted];
        }]];
        return [SKDisposable disposableWithBlock:^{
            [self removeTarget:subscriber action:@selector(sendNext:)];
        }];
    }];
}

@end
