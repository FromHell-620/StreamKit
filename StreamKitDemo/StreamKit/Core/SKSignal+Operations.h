//
//  SKSignal+Operations.h
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKSignal.h"

@class SKMulticastConnection;
@class SKSubject;
@class SKDisposable;


FOUNDATION_EXTERN NSString * const SKSignalErrorDomain;

FOUNDATION_EXTERN const NSUInteger SKSignalErrorTimeout;

@interface SKSignal (Operations)

/**
 Call next when signal's next event come.

 @param next Do what you want to do
 @return A new signal.
 */
- (SKSignal *)doNext:(void (^)(id x))next;

/**
 Call block when signal's error event come.
 
 @param block Do what you want to do
 @return A new signal.
 */
- (SKSignal *)doError:(void (^)(NSError *error))block;

/**
 Call block when signal's completed event come.
 
 @param block Do what you want to do
 @return A new signal.
 */
- (SKSignal *)doCompleted:(void (^)(void))block;

/**
 Current-limiting
 `next` block will current-limiting on the return signal.
 */
- (SKSignal *)throttle:(NSTimeInterval)interval;

- (SKSignal *)throttle:(NSTimeInterval)interval valuesPredicate:(BOOL (^)(id x))predicate;

- (SKSignal *)delay:(NSTimeInterval)interval;

- (SKSignal *)delay:(NSTimeInterval)interval valuesPredicate:(BOOL (^)(id x))predicate;

- (SKSignal *)catch:(SKSignal *(^)(NSError *error))errorBlock;

- (SKSignal *)catchTo:(SKSignal *)signal;

- (SKSignal *)initially:(dispatch_block_t)block;

- (SKSignal *)finally:(dispatch_block_t)block;

+ (SKSignal *)defer:(SKSignal *(^)(void))block;

- (SKSignal *)bufferWithTime:(NSTimeInterval)interval;

- (SKSignal *)bufferWithTime:(NSTimeInterval)interval onScheduler:(SKScheduler *)scheduler;

- (SKSignal *)takeLast;

- (SKSignal *)takeLast:(NSInteger)count;

- (SKSignal *)combineLatestWithSignal:(SKSignal *)signal;

+ (SKSignal *)combineLatestWithSignals:(NSArray<SKSignal *> *)signals;

+ (SKSignal *)combineLatest:(NSArray<SKSignal *> *)signals reduce:(id (^)())reduceBlock;

+ (SKSignal *)join:(NSArray<SKSignal *> *)signals block:(SKSignal *(^)(id left,id right))block;

- (SKSignal *)flattenMap:(SKSignal*(^)(id value))block;

- (SKSignal *)reduceEach:(id (^)())block;

- (SKSignal *)map:(id(^)(id x))block;

- (SKSignal *)mapReplace:(id)value;

- (SKSignal *)filter:(BOOL(^)(id x))block;

- (SKSignal *)flatten;

- (SKSignal *)merge:(SKSignal *)signal;

+ (SKSignal *)merge:(NSArray<SKSignal *> *)signals;

/**
This function subscribes to all incoming signals but only the number of maxConcurrent subscriptions.
 if maxConcurrent is 0,then subscribe all signals
 @param maxConcurrent The maximum number of one-time subscriptions
 @return New signal
 */
- (SKSignal *)flatten:(NSInteger)maxConcurrent;

/**
 Do flatten:1.
 */
- (SKSignal *)concat;

- (SKSignal *)concat:(SKSignal *)signal;

+ (SKSignal *)concat:(NSArray<SKSignal *> *)signals;

+ (SKSignal *)interval:(NSTimeInterval)interval;

+ (SKSignal *)interval:(NSTimeInterval)interval onScheduler:(SKScheduler *)scheduler;

+ (SKSignal *)interval:(NSTimeInterval)interval onScheduler:(SKScheduler *)scheduler withLeeway:(NSTimeInterval)leeway;

- (SKSignal *)takeUntil:(SKSignal *)other;

- (SKSignal *)takeUntilReplacement:(SKSignal *)replacement;

- (SKSignal *)startWith:(id)value;

- (SKSignal *)ignore:(id)value;

- (SKSignal *)ignoreValues;

- (SKSignal *)aggregateWithStart:(id)startValue reduceBlock:(id (^)(id running,id next))block;

- (SKSignal *)aggregateWithStart:(id)startValue withIndexReduceBlock:(id (^)(id running,id next,NSInteger index))block;

- (SKSignal *)scanWithStart:(id)startValue reduceBlock:(id (^)(id running,id next))block;

- (SKSignal *)scanWithStart:(id)startValue withIndexReduceBlock:(id (^)(id running, id next,NSInteger index))block;

- (id)first;

- (id)firstWithDefault:(id)defaultValue;

- (SKSignal *)collect;

- (SKSignal *)combinePreviousWithStart:(id)start reduce:(id (^)(id previous, id next))reduceBlock;

- (SKSignal *)zipWith:(SKSignal *)other;

+ (SKSignal *)zip:(NSArray<SKSignal *> *)signals;

+ (SKSignal *)zip:(NSArray<SKSignal *> *)signals reduce:(id (^)())block;

- (SKSignal *)distinctUntilChanged;

- (SKSignal *)take:(NSUInteger)takes;

- (SKSignal *)takeUntilBlock:(BOOL(^)(id x))block;

- (SKSignal *)takeWhileBlock:(BOOL(^)(id x))block;

- (SKSignal *)skip:(NSUInteger)takes;

- (SKSignal *)skipUntilBlock:(BOOL(^)(id x))block;

- (SKSignal *)skipWhileBlock:(BOOL(^)(id x))block;

- (SKSignal *)Y;

- (SKSignal *)N;

- (SKSignal *)not;

- (SKSignal *)scheduleOn:(SKScheduler *)scheduler;

- (SKMulticastConnection *)publish;

- (SKMulticastConnection *)multicast:(SKSubject *)subject;

- (SKSignal *)replay;

- (SKSignal *)replayLast;

- (SKSignal *)timeout:(NSTimeInterval)interval;

- (SKSignal *)timeout:(NSTimeInterval)interval onScheduler:(SKScheduler *)scheduler;

- (SKDisposable *)setKeyPath:(NSString *)keyPath onObject:(id)onObject;

- (SKDisposable *)setKeyPath:(NSString *)keyPath onObject:(id)onObject nilValue:(id)nilValue;

- (SKDisposable *)invokeAction:(SEL)selector onTarget:(id)target;

- (SKSignal *)switchToLatest;

+ (SKSignal *)if:(SKSignal *)boolSignal then:(SKSignal *)trueSignal else:(SKSignal *)falseSignal;

@end
