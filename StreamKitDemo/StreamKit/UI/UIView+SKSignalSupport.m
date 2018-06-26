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
#import "SKObjectifyMarco.h"
#import "SKSubscriber.h"
#import "UIGestureRecognizer+SKSignalSupport.h"

@implementation UIView (SKSignalSupport)

- (SKSignal *)sk_clickSignal {
    @unsafeify(self)
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        @strongify(self)
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
        SKSignal *gestureDisposable = [[tap sk_eventSignal] subscribeNext:^(id x) {
            [subscriber sendNext:self];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
    }]
}

@end
