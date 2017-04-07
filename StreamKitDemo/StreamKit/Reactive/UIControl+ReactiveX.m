//
//  UIControl+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/5.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "UIControl+ReactiveX.h"
#import "UIControl+StreamKit.h"
#import "SKObjectifyMarco.h"
#import "SKSubscriber.h"
#import "SKSignal.h"

@implementation UIControl (ReactiveX)

- (SKSignal*)sk_signalForControlEvents:(UIControlEvents)controlEvents
{
    @weakify(self)
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        @strongify(self)
        self.sk_addEventBlock(controlEvents,^(UIControl* control) {
            [subscriber sendNext:control];
        });
    }];
    
}

@end
