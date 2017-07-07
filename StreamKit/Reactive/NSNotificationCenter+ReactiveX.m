//
//  NSNotificationCenter+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/7/8.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "NSNotificationCenter+ReactiveX.h"
#import "NSNotificationCenter+StreamKit.h"
#import "SKSignal.h"
#import "SKSubscriber.h"

@implementation NSNotificationCenter (ReactiveX)

- (SKSignal *)sk_signalWithName:(NSNotificationName)name observer:(id)observer {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        self.sk_addNotificationToObserver(name,observer,^(NSNotification *noti){
            [subscriber sendNext:noti];
        });
    }];
}

@end
