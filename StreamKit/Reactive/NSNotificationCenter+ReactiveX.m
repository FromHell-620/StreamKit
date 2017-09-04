//
//  NSNotificationCenter+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/7/8.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "NSNotificationCenter+ReactiveX.h"
#import "NSNotificationCenter+StreamKit.h"
#import "SKObjectifyMarco.h"
#import "SKSignal.h"
#import "SKSubscriber.h"

@implementation NSNotificationCenter (ReactiveX)

- (SKSignal *)sk_signalWithName:(NSNotificationName)name object:(id)object {
    @weakify(object)
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        @strongify(object)
        [self addObserverForName:name object:object queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [subscriber sendNext:note];
        }];
        
    }];
}

@end
