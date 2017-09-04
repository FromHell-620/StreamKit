//
//  SKSignal.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/31.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKSubscriber;

@class SKScheduler;

@interface SKSignal<ObjectType> : NSObject

@property (nonatomic,copy) NSString *debugName;

+ (instancetype)signalWithBlock:(void(^)(id<SKSubscriber> subscriber))block;

- (void)subscribe:(id<SKSubscriber>)subscriber;

- (void)subscribeNext:(void(^)(ObjectType x))next;

- (void)subscribeError:(void(^)(NSError* error))error;

- (void)subscribeNext:(void (^)(ObjectType x))next
                error:(void(^)(NSError *error))error;

- (void)subscribe:(void (^)(ObjectType x))next
         complete:(void(^)(id value))complete;

- (void)subscribeNext:(void (^)(ObjectType x))next
                error:(void(^)(NSError* error))error
             complete:(void(^)(id value))complete;

- (void)subscribeWithReturnValue:(id(^)(id x))next;

- (void)subscribeWithReturnValue:(id(^)(id x))next
                        complete:(id(^)(id x))complete;

@end

@interface SKSignal (Debug)

- (SKSignal *)setSignalName:(NSString *)name;

@end

@interface SKSignal<ObjectType> (operation)

- (SKSignal *)doNext:(void(^)(ObjectType x))next;

- (SKSignal *)concat:(SKSignal *)signal;

- (SKSignal *)flattenMap:(SKSignal*(^)(id value))block;

- (SKSignal *)map:(id(^)(id x))block;

- (SKSignal<ObjectType> *)filter:(BOOL(^)(ObjectType x))block;

- (SKSignal<ObjectType> *)ignore:(id)value;

- (SKSignal *)takeUntil:(SKSignal*)signal;

- (SKSignal<ObjectType> *)distinctUntilChanged;

- (SKSignal<ObjectType> *)take:(NSUInteger)takes;

- (SKSignal<ObjectType> *)takeUntilBlock:(BOOL(^)(id x))block;

- (SKSignal<ObjectType> *)takeWhileBlock:(BOOL(^)(id x))block;

- (SKSignal<ObjectType> *)skip:(NSUInteger)takes;

- (SKSignal<ObjectType> *)skipUntilBlock:(BOOL(^)(id x))block;

- (SKSignal<ObjectType> *)skipWhileBlock:(BOOL(^)(id x))block;

- (SKSignal<ObjectType> *)startWith:(id)value;

- (SKSignal<ObjectType> *)startWithBlock:(void(^)(id x))block;

- (SKSignal *)combineLatestWithSignal:(SKSignal *)signal;

+ (SKSignal *)combineLatestSignals:(NSArray<SKSignal *> *)signals;

- (SKSignal<ObjectType> *)throttle:(NSTimeInterval)interval;

- (SKSignal<ObjectType> *)Y;

- (SKSignal<ObjectType> *)N;

- (SKSignal<ObjectType> *)not;

- (SKSignal<ObjectType> *)scheduleOn:(SKScheduler *)scheduler;

@end
