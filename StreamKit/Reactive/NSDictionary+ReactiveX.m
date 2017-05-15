//
//  NSDictionary+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/5/8.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "NSDictionary+ReactiveX.h"
#import "SKSubscriber.h"
#import "SKSignal.h"
@implementation NSDictionary (ReactiveX)

- (SKSignal*)sk_enumSignal {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [subscriber sendNext:key];
        }];
        [subscriber sendComplete:nil];
    }];
}

@end
