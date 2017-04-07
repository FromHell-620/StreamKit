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

- (void)sendComplete:(id)value;

@end

@interface SKSubscriber : NSObject <SKSubscriber>

+ (instancetype)subscriberWithNext:(void(^)(id value))next
                          complete:(void(^)(id value))complete;


@end
