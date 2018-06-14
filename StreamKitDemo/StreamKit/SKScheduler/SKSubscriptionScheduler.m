//
//  SKSubscriptionScheduler.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKSubscriptionScheduler.h"
#import "SKConcurrentQueueScheduler.h"

@interface SKSubscriptionScheduler ()

@property (nonatomic,strong) SKConcurrentQueueScheduler *backgroundScheduler;

@end

@implementation SKSubscriptionScheduler

+ (BOOL)isMainThread {
    return [NSThread currentThread].isMainThread;
}

- (instancetype)initWithQos:(NSQualityOfService)qos {
    self = [super init];
    if (self) {
        self.backgroundScheduler = [[SKConcurrentQueueScheduler alloc] initWithQos:qos];
    }
    return self;
}

- (SKDisposable *)schedule:(dispatch_block_t)block {
    NSCParameterAssert(block);
    if ([SKSubscriptionScheduler isMainThread]) {
        block();
        return nil;
    }
    return [self.backgroundScheduler schedule:block];
}

- (SKDisposable *)afterDelay:(NSTimeInterval)delay schedule:(dispatch_block_t)block {
    return [([self.class isMainThread] ? [SKScheduler mainThreadScheduler] : self.backgroundScheduler) afterDelay:delay schedule:block];
}

- (SKDisposable *)afterDelay:(NSTimeInterval)delay repeating:(NSTimeInterval)interval withLeeway:(NSTimeInterval)leeway schedule:(void (^)(void))block {
    return [([self.class isMainThread] ? [SKScheduler mainThreadScheduler] : self.backgroundScheduler) afterDelay:delay repeating:interval withLeeway:leeway schedule:block];

}

@end
