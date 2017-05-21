//
//  SKSignal.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/31.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKSubscriber;
@interface SKSignal : NSObject

+ (instancetype)signalWithBlock:(void(^)(id<SKSubscriber> subscriber))block;

- (void)subscribe:(id<SKSubscriber>)subscriber;

- (void)subscribeNext:(void(^)(id x))next;

- (void)subscribeError:(void(^)(NSError* error))error;

- (void)subscribeNext:(void (^)(id x))next
                error:(void(^)(NSError *error))error;

- (void)subscribe:(void (^)(id x))next
         complete:(void(^)(id value))complete;

- (void)subscribeNext:(void (^)(id x))next
                error:(void(^)(NSError* error))error
             complete:(void(^)(id value))complete;

- (void)subscribeWithReturnValue:(id(^)(id x))next;

- (void)subscribeWithReturnValue:(id(^)(id x))next
                        complete:(id(^)(id x))complete;

@end

@interface SKSignal (operation)

- (SKSignal *)doNext:(void(^)(id x))next;

- (SKSignal*)concat:(void(^)(id<SKSubscriber> subscriber))block;

- (SKSignal*)flattenMap:(SKSignal*(^)(id value))block;

- (SKSignal*)map:(id(^)(id x))block;

- (SKSignal*)filter:(BOOL(^)(id x))block;

- (SKSignal*)ignore:(id)value;

- (SKSignal*)takeUntil:(SKSignal*)signal;

- (SKSignal*)distinctUntilChanged;

- (SKSignal*)take:(NSUInteger)takes;

- (SKSignal*)takeUntilBlock:(BOOL(^)(id x))block;

- (SKSignal*)takeWhileBlock:(BOOL(^)(id x))block;

- (SKSignal*)skip:(NSUInteger)takes;

- (SKSignal*)skipUntilBlock:(BOOL(^)(id x))block;

- (SKSignal*)skipWhileBlock:(BOOL(^)(id x))block;

- (SKSignal*)startWith:(id)value;

- (SKSignal *)startWithBlock:(void(^)(id x))block;

- (SKSignal*)combineLatestWithSignal:(SKSignal*)signal;

+ (SKSignal*)combineLatestSignals:(NSArray<SKSignal*>*)signals;

- (SKSignal*)throttle:(NSTimeInterval)interval;

- (SKSignal *)Y;

- (SKSignal *)N;

- (SKSignal *)not;

@end
