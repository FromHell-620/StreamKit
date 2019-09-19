//
//  UIView+SKSignalSupport.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/26.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "UIView+SKSignalSupport.h"
#import "SKSignal.h"
#import "SKDisposable.h"
#import "SKCompoundDisposable.h"
#import "SKObjectifyMarco.h"
#import "SKSubscriber.h"
#import "UIGestureRecognizer+SKSignalSupport.h"
#import "NSObject+SKDeallocating.h"
#import <objc/runtime.h>

@implementation UIView (SKSignalSupport)

- (UITapGestureRecognizer *)_clickRecognizer {
    UITapGestureRecognizer *tap = objc_getAssociatedObject(self, _cmd);
    if (!tap) {
        tap = [UITapGestureRecognizer new];
        objc_setAssociatedObject(self, _cmd, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tap;
}

- (SKSignal *)sk_clickSignal {
    @unsafeify(self)
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        @strongify(self)
        SKCompoundDisposable *selfDisposable = [SKCompoundDisposable disposableWithBlock:nil];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [self _clickRecognizer];
        [self addGestureRecognizer:tap];
        SKDisposable *gestureDisposable = [[tap sk_eventSignal] subscribeNext:^(id x) {
            [subscriber sendNext:self];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
        [self.deallocDisposable addDisposable:[SKDisposable disposableWithBlock:^{
            [subscriber sendCompleted];
        }]];
        [selfDisposable addDisposable:gestureDisposable];
        [selfDisposable addDisposable:[SKDisposable disposableWithBlock:^{
            @strongify(self)
            [self removeGestureRecognizer:tap];
        }]];
        return selfDisposable;
    }];
}

@end
