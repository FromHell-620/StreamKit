//
//  FHScheduler.h
//  FHSchedulerDemo
//
//  Created by 李浩 on 2017/7/23.
//  Copyright © 2017年 GodL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKDisposable;

@interface SKScheduler : NSObject

+ (instancetype)mainThreadScheduler;

+ (instancetype)serialScheduler;

+ (instancetype)serialSchedulerWithQos:(NSQualityOfService)qos;

+ (instancetype)concurrentScheduler;

+ (instancetype)concurrentSchedulerWithQos:(NSQualityOfService)qos;

+ (instancetype)subscriptionScheduler;

- (SKDisposable *)schedule:(dispatch_block_t)block;

- (SKDisposable *)afterDelay:(NSTimeInterval)delay schedule:(dispatch_block_t)block;

- (SKDisposable *)afterDelay:(NSTimeInterval )delay
                   repeating:(NSTimeInterval)interval
                  withLeeway:(NSTimeInterval)leeway
                    schedule:(void (^)(void))block;

@end
