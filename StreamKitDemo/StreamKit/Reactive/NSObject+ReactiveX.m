//
//  NSObject+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/7.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "NSObject+ReactiveX.h"
#import "NSObject+StreamKit.h"
#import "SKObjectifyMarco.h"
#import "SKSignal.h"
#import "SKSubscriber.h"

@implementation NSObject (ReactiveX)

- (SKSignal*)sk_ObserveForKeyPath:(NSString*)keypath
{
    @weakify(self)
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        @strongify(self)
        self.sk_addObserverWithKeyPath(keypath,^(NSDictionary* change){
            [subscriber sendNext:change];
        });
    }];
}

@end
