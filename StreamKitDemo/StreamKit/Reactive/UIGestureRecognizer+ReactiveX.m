//
//  UIGestureRecognizer+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/7.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "UIGestureRecognizer+ReactiveX.h"
#import "UIGestureRecognizer+StreamKit.h"
#import "SKSignal.h"
#import "SKSubscriber.h"
#import "SKObjectifyMarco.h"

@implementation UIGestureRecognizer (ReactiveX)

- (SKSignal*)sk_eventSignal
{
    @weakify(self)
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
       @strongify(self)
        self.sk_addTargetBlock(^(UIGestureRecognizer* recognizer) {
            [subscriber sendNext:recognizer];
        });
    }];
}

@end
