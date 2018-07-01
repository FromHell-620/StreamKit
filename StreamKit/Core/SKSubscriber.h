//
//  SKSubscriber.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/5.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKCompoundDisposable;

@protocol SKSubscriber <NSObject>

@required


/**
 Send value to subscribers.

 @param value The value send to subscribers.
 */
- (void)sendNext:(id)value;

/**
 Send error to subscribers.

 @param error The error to send to subscribers.
 This will terminate the signal.
 */
- (void)sendError:(NSError*)error;

/**
 Send completed to subscribers.
 
 This will terminate the signal.
 */
- (void)sendCompleted;

- (void)didSubscriberWithDisposable:(SKCompoundDisposable *)other;

@optional

- (id)sendNextWithReturnValue:(id)value;

- (id)sendCompleteWithReturnValue:(id)value;

@end

@interface SKSubscriber : NSObject <SKSubscriber>

+ (instancetype)subscriberWithNext:(void (^)(id))next
                             error:(void (^)(NSError* error))error
                          completed:(void (^)(void))completed;


@end
