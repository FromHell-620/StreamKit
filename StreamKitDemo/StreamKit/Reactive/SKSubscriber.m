//
//  SKSubscriber.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/5.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSubscriber.h"
#import "SKObjectifyMarco.h"

@implementation SKSubscriber {
    void(^_next)(id value);
    void(^_complete)(id value);
}

+ (instancetype)subscriberWithNext:(void(^)(id value))next
                          complete:(void(^)(id value))complete
{
    SKSubscriber* subscriber = [SKSubscriber new];
    subscriber->_next = [next copy];
    subscriber->_complete = [complete copy];
    return subscriber;
}

- (void)sendNext:(id)value
{
    if(_next) _next(value);
}

- (void)sendComplete:(id)value
{
    if (_complete) ^{_complete(value);_next = nil;_complete = nil;}();
}

- (void)dealloc
{

}

@end
