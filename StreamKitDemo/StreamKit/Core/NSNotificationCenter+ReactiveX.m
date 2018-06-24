//
//  NSNotificationCenter+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/7/8.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "NSNotificationCenter+ReactiveX.h"
#import "SKObjectifyMarco.h"
#import "SKSignal.h"
#import "SKSubscriber.h"
#import "SKDisposable.h"

@implementation NSNotificationCenter (ReactiveX)

- (SKSignal *)sk_signalWithName:(NSNotificationName)name object:(id)object {
    @weakify(self)
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        @strongify(self)
        [self addObserver:subscriber selector:@selector(sendNext:) name:name object:object];
        
        return [SKDisposable disposableWithBlock:^{
            [self removeObserver:subscriber name:name object:object];
        }];
    }];
}

@end
