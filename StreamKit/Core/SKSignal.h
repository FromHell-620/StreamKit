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
@class SKDisposable;

@interface SKSignal<ObjectType> : NSObject

+ (instancetype)signalWithBlock:(SKDisposable *(^)(id<SKSubscriber> subscriber))block;

+ (instancetype)return:(id)value;

+ (instancetype)error:(NSError *)error;

+ (instancetype)empty;

+ (instancetype)nerver;

@end

@interface SKSignal<ObjectType> (Subscriber)

/**
 Send a subscriber to this signal

 @param subscriber  A object which conform SKSubscriber protocol.
 @return You can user the return value to end this subscriber.
 */
- (SKDisposable *)subscribe:(id<SKSubscriber>)subscriber;

/**
 Subscriber the next events

 @param next This block will call when next event become.
 */
- (SKDisposable *)subscribeNext:(void(^)(ObjectType x))next;

/**
 Subscriber the error events.

 @param error This block will call when next event become.
 */
- (SKDisposable *)subscribeError:(void(^)(NSError* error))error;

/**
 Subscriber the completed events.

 @param completed This block will call when completed event become.
 */
- (SKDisposable *)subscribeCompleted:(void(^)(void))completed;

/**
 Subscriber the next, error events
 */
- (SKDisposable *)subscribeNext:(void(^)(ObjectType x))next
                error:(void(^)(NSError *error))error;

/**
 Subscriber the next,completed events
 */
- (SKDisposable *)subscribeNext:(void(^)(ObjectType x))next
             completed:(void(^)(void))completed;

/**
 Subscriber the next,error,completed events
 */
- (SKDisposable *)subscribeNext:(void(^)(ObjectType x))next
                error:(void(^)(NSError* error))error
             completed:(void(^)(void))completed;

- (void)subscribeWithReturnValue:(id(^)(ObjectType x))next;

- (void)subscribeWithReturnValue:(id(^)(ObjectType x))next
                        complete:(id(^)(ObjectType x))complete;

@end

