//
//  SKSignal+Operations.h
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKSignal.h"

@interface SKSignal (Operations)

- (SKSignal *)doNext:(void(^)(ObjectType x))next;

- (SKSignal *)concat:(SKSignal *)signal;

- (SKSignal *)flattenMap:(SKSignal*(^)(ObjectType value))block;

- (SKSignal *)map:(id(^)(ObjectType x))block;

- (SKSignal<ObjectType> *)filter:(BOOL(^)(ObjectType x))block;

- (SKSignal<ObjectType> *)ignore:(ObjectType)value;

- (SKSignal *)takeUntil:(SKSignal *)signal;

- (SKSignal<ObjectType> *)distinctUntilChanged;

- (SKSignal<ObjectType> *)take:(NSUInteger)takes;

- (SKSignal<ObjectType> *)takeUntilBlock:(BOOL(^)(id x))block;

- (SKSignal<ObjectType> *)takeWhileBlock:(BOOL(^)(id x))block;

- (SKSignal<ObjectType> *)skip:(NSUInteger)takes;

- (SKSignal<ObjectType> *)skipUntilBlock:(BOOL(^)(id x))block;

- (SKSignal<ObjectType> *)skipWhileBlock:(BOOL(^)(id x))block;

- (SKSignal<ObjectType> *)startWith:(ObjectType)value;

- (SKSignal<ObjectType> *)startWithBlock:(void(^)(id x))block;

- (SKSignal *)combineLatestWithSignal:(SKSignal *)signal;

+ (SKSignal *)combineLatestSignals:(NSArray<SKSignal *> *)signals;

- (SKSignal<ObjectType> *)throttle:(NSTimeInterval)interval;

- (SKSignal<ObjectType> *)Y;

- (SKSignal<ObjectType> *)N;

- (SKSignal<ObjectType> *)not;

- (SKSignal<ObjectType> *)scheduleOn:(SKScheduler *)scheduler;

@end
