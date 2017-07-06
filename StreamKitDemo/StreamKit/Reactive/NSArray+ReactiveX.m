//
//  NSArray+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/5/8.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "NSArray+ReactiveX.h"
#import "SKSignal.h"

@implementation NSArray (ReactiveX)

- (SKSignal*)sk_enumSignal {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [subscriber sendNext:obj];
        }];
        [subscriber sendComplete:nil];
    }];
}

- (void)sendNext:(id)value {
    [[self sk_enumSignal] subscribeNext:^(id<SKSubscriber> x) {
        if ([x respondsToSelector:@selector(sendNext:)]) {
            [x sendNext:value];
        }
    }];
}

- (void)sendError:(NSError *)error {
    [[self sk_enumSignal] subscribeNext:^(id<SKSubscriber> x) {
        if ([x respondsToSelector:@selector(sendError:)]) {
            [x sendError:error];
        }
    }];
}

- (void)sendComplete:(id)value {
    [[self sk_enumSignal] subscribeNext:^(id x) {
        if ([x respondsToSelector:@selector(sendComplete:)]) {
            [x sendComplete:value];
        }
    }];
}

@end
