//
//  NSArray+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/5/8.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "NSArray+ReactiveX.h"
#import "SKSignal.h"
#import "SKSubscriber.h"

@implementation NSArray (ReactiveX)

- (SKSignal*)sk_enumSignal {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [subscriber sendNext:obj];
        }];
        [subscriber sendComplete:nil];
    }];
}

@end
