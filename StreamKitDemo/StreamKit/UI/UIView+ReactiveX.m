//
//  UIView+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/7.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "UIView+ReactiveX.h"
#import "UIView+StreamKit.h"
#import "SKSubscriber.h"
#import "SKObjectifyMarco.h"

@implementation UIView (ReactiveX)

- (SKSignal*)sk_eventSignal
{
    @weakify(self)
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        return nil;
    }];
}

@end
