//
//  SKSignal+Operations.h
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKSignal.h"

@interface SKSignal (Operations)

/**
 Call next when signal's next event come.

 @param next Do what you want do
 @return A new signal.
 */
- (SKSignal *)doNext:(void (^)(id x))next;

- (SKSignal *)doError:(void (^)(NSError *error))block;

- (SKSignal *)doCompleted:(void (^)(void))block;

- (SKSignal *)concat:(SKSignal *)signal;

- (SKSignal *)flattenMap:(SKSignal*(^)(id value))block;

- (SKSignal *)map:(id(^)(id x))block;

- (SKSignal *)filter:(BOOL(^)(id x))block;

- (SKSignal *)ignore:(id)value;

- (SKSignal *)takeUntil:(SKSignal *)signal;

- (SKSignal *)distinctUntilChanged;

- (SKSignal *)take:(NSUInteger)takes;

- (SKSignal *)takeUntilBlock:(BOOL(^)(id x))block;

- (SKSignal *)takeWhileBlock:(BOOL(^)(id x))block;

- (SKSignal *)skip:(NSUInteger)takes;

- (SKSignal *)skipUntilBlock:(BOOL(^)(id x))block;

- (SKSignal *)skipWhileBlock:(BOOL(^)(id x))block;

- (SKSignal *)startWith:(id)value;

- (SKSignal *)startWithBlock:(void(^)(id x))block;

- (SKSignal *)combineLatestWithSignal:(SKSignal *)signal;

+ (SKSignal *)combineLatestSignals:(NSArray<SKSignal *> *)signals;

- (SKSignal *)throttle:(NSTimeInterval)interval;

- (SKSignal *)Y;

- (SKSignal *)N;

- (SKSignal *)not;

- (SKSignal *)scheduleOn:(SKScheduler *)scheduler;

@end
