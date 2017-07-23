//
//  FHQueueScheduler.m
//  FHSchedulerDemo
//
//  Created by 李浩 on 2017/7/23.
//  Copyright © 2017年 GodL. All rights reserved.
//

#import "SKQueueScheduler.h"

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
    NSAssert(NO, @"must overwrite with subclass");
    return nil;
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        _queue = queue;
    }
    return self;
}

- (void)schedule:(dispatch_block_t)block {
    [self afterDelay:0 schedule:block];
}

- (void)afterDelay:(NSTimeInterval)delay schedule:(dispatch_block_t)block {
    NSCParameterAssert(block);
    if (self.queue == nil) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), self.queue, ^{
        block();
    });
}

@end
