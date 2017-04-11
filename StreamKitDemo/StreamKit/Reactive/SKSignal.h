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

- (void)subscribe:(void(^)(id x))next;

- (void)subscribe:(void (^)(id value))next complete:(void(^)(id value))complete;

@end

@interface SKSignal (operation)

- (SKSignal*)concat:(void(^)(id<SKSubscriber> subscriber))block;

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

- (SKSignal*)combineLatestWithSignal:(SKSignal*)signal;

@end
