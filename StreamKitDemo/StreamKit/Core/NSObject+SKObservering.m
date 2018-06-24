//
//  NSObject+SKObserveing.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/24.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "NSObject+SKObserveing.h"
#import "SKSignal.h"
#import "SKDisposable.h"

//@interface _SKObserve

@implementation NSObject (SKObservering)

- (SKSignal *)sk_observerWithKeyPath:(NSString *)keyPath {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        [self addObserver:<#(nonnull NSObject *)#> forKeyPath:<#(nonnull NSString *)#> options:<#(NSKeyValueObservingOptions)#> context:<#(nullable void *)#>]
        return nil;
    }];
}

@end
