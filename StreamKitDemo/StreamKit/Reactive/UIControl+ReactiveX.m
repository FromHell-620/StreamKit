//
//  UIControl+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/5.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "UIControl+ReactiveX.h"
#import "SKSignal+Operations.h"
#import "SKObjectifyMarco.h"
#import "SKSubscriber.h"
#import "SKDisposable.h"
#import "SKCompoundDisposable.h"
#import "NSObject+SKDeallocating.h"

@implementation UIControl (ReactiveX)

- (SKSignal*)sk_signalForControlEvents:(UIControlEvents)controlEvents
{
    @weakify(self)
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        @strongify(self)
        [self addTarget:subscriber action:@selector(sendNext:) forControlEvents:controlEvents];
        [self.deallocDisposable addDisposable:[SKDisposable disposableWithBlock:^{
            [subscriber sendCompleted];
        }]];
        return [SKDisposable disposableWithBlock:^{
            [self removeTarget:subscriber action:@selector(sendNext:) forControlEvents:controlEvents];
        }];
    }];
}

- (SKSignal *)sk_eventSignal {
    return [self sk_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
