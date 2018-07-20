//
//  FHScheduler.m
//  FHSchedulerDemo
//
//  Created by 李浩 on 2017/7/23.
//  Copyright © 2017年 GodL. All rights reserved.
//

#import "SKScheduler.h"
#import "SKMainQueueScheduler.h"
#import "SKSerialQueueScheduler.h"
#import "SKConcurrentQueueScheduler.h"
#import "SKSubscriptionScheduler.h"

@implementation SKScheduler

FOUNDATION_STATIC_INLINE SKScheduler *FHSerialQosScheduler(NSQualityOfService qos) {
    static NSMutableDictionary<NSNumber *,SKScheduler *> *schedulerPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schedulerPool = [NSMutableDictionary dictionary];
    });
    SKScheduler *scheduler = [schedulerPool objectForKey:@(qos)];
    if (!scheduler) {
        @synchronized (schedulerPool) {
            scheduler = [[SKSerialQueueScheduler alloc] initWithQos:qos];
            [schedulerPool setObject:scheduler forKey:@(qos)];
        }
    }
    return scheduler;
}

FOUNDATION_STATIC_INLINE SKScheduler *FHConcurrentQosScheduler(NSQualityOfService qos) {
    static NSMutableDictionary<NSNumber *,SKScheduler *> *schedulerPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schedulerPool = [NSMutableDictionary dictionary];
    });
    SKScheduler *scheduler = [schedulerPool objectForKey:@(qos)];
    if (!scheduler) {
        @synchronized (schedulerPool) {
            scheduler = [[SKConcurrentQueueScheduler alloc] initWithQos:qos];
            [schedulerPool setObject:scheduler forKey:@(qos)];
        }
    }
    return scheduler;
}

+ (instancetype)mainThreadScheduler {
    static SKMainQueueScheduler *main = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        main = [[SKMainQueueScheduler alloc] initWithQueue:nil];
    });
    return main;
}

+ (instancetype)subscriptionScheduler {
    static SKSubscriptionScheduler *scheduler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scheduler = [[SKSubscriptionScheduler alloc] initWithQos:NSQualityOfServiceDefault];
    });
    return scheduler;
}

+ (instancetype)serialScheduler {
    return [self serialSchedulerWithQos:NSQualityOfServiceDefault];
}

+ (instancetype)serialSchedulerWithQos:(NSQualityOfService)qos {
    return FHSerialQosScheduler(qos);
}

+ (instancetype)concurrentScheduler {
    return [self concurrentSchedulerWithQos:NSQualityOfServiceDefault];
}

+ (instancetype)concurrentSchedulerWithQos:(NSQualityOfService)qos {
    return FHConcurrentQosScheduler(qos);
}

- (SKDisposable *)schedule:(dispatch_block_t)block {
    return [self afterDelay:0 schedule:block];
}

- (SKDisposable *)afterDelay:(NSTimeInterval)delay schedule:(dispatch_block_t)block {
    NSCAssert(NO, @"must overwrite with subclass");
    return nil;
}

- (SKDisposable *)afterDelay:(NSTimeInterval)delay repeating:(NSTimeInterval)interval withLeeway:(NSTimeInterval)leeway schedule:(void (^)(void))block {
    return nil;
    
}

@end
