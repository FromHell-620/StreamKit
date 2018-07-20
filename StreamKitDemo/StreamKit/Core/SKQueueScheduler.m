//
//  FHQueueScheduler.m
//  FHSchedulerDemo
//
//  Created by 李浩 on 2017/7/23.
//  Copyright © 2017年 GodL. All rights reserved.
//

#import "SKQueueScheduler.h"
#import "SKDisposable.h"

@implementation SKQueueScheduler

dispatch_qos_class_t FHQueueQosWithQuality(NSQualityOfService qos) {
    switch (qos) {
            case NSQualityOfServiceUserInteractive:return QOS_CLASS_USER_INTERACTIVE;
            case NSQualityOfServiceUserInitiated:return QOS_CLASS_USER_INITIATED;
            case NSQualityOfServiceBackground:return QOS_CLASS_BACKGROUND;
            case NSQualityOfServiceUtility:return QOS_CLASS_UTILITY;
            case NSQualityOfServiceDefault:return QOS_CLASS_DEFAULT;
        default:return QOS_CLASS_UNSPECIFIED;
    }
}

- (instancetype)initWithQos:(NSQualityOfService)qos {
    NSCAssert(NO, @"must overwrite with subclass");
    return nil;
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        _queue = queue;
    }
    return self;
}

- (SKDisposable *)schedule:(dispatch_block_t)block {
    return [self afterDelay:0 schedule:block];
}

- (SKDisposable *)afterDelay:(NSTimeInterval)delay schedule:(dispatch_block_t)block {
    NSCParameterAssert(block);
    if (self.queue == nil) return nil;
    dispatch_block_t dispatch_block = dispatch_block_create(0, block);
    SKDisposable *dispose = [SKDisposable disposableWithBlock:^{
        dispatch_block_cancel(dispatch_block);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), self.queue, ^{
        dispatch_block();
    });
    return dispose;
}

- (SKDisposable *)afterDelay:(NSTimeInterval)delay repeating:(NSTimeInterval)interval withLeeway:(NSTimeInterval)leeway schedule:(void (^)(void))block {
    NSCParameterAssert(block);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, leeway * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        block();
    });
    dispatch_resume(timer);
    SKDisposable *disposable = [SKDisposable disposableWithBlock:^{
        dispatch_source_cancel(timer);
    }];
    return disposable;
}

@end
