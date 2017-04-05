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

- (void)subscribe:(void(^)(id x))send;

@end

@interface SKSignal (operation)

- (SKSignal*)concat:(void(^)(id<SKSubscriber> subscriber))block;

- (SKSignal*)map:(id(^)(id x))block;



@end
