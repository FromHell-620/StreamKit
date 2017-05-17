//
//  SKSubscriber.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/5.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKSubscriber <NSObject>

- (void)sendNext:(id)value;

- (void)sendError:(NSError*)error;

- (id)sendNextWithReturnValue:(id)value;

- (void)sendComplete:(id)value;

- (id)sendCompleteWithReturnValue:(id)value;

@end

@interface SKSubscriber : NSObject <SKSubscriber>

+ (instancetype)subscriberWithNext:(void(^)(id value))next
                          complete:(void(^)(id value))complete;


+ (instancetype)subscriberWithReturnValueNext:(id)next
                                     complete:(id)complete;

+ (instancetype)subscriberWithNext:(void (^)(id))next
                             error:(void(^)(NSError* error))error
                          complete:(void (^)(id))complete;


@end
