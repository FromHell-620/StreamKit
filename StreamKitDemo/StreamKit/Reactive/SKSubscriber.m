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
    void(^_error)(NSError* error);
    void(^_complete)(id value);
    
    id (^_nextWithReturnValue)(id value);
    id (^_completeWithReturnValue)(id value);
}

+ (instancetype)subscriberWithNext:(void(^)(id value))next
                          complete:(void(^)(id value))complete {
    return [SKSubscriber subscriberWithNext:next error:nil complete:complete];
}

+ (instancetype)subscriberWithReturnValueNext:(id)next
                                     complete:(id)complete {
    SKSubscriber* subscriber = [SKSubscriber new];
    subscriber->_nextWithReturnValue = [next copy];
    subscriber->_completeWithReturnValue = [complete copy];
    return subscriber;
}

+ (instancetype)subscriberWithNext:(void (^)(id))next
                             error:(void(^)(NSError* error))error
                          complete:(void (^)(id))complete {
    SKSubscriber *subscriber = [SKSubscriber new];
    subscriber->_next = [next copy];
    subscriber->_error = [error copy];
    subscriber->_complete = [complete copy];
    return subscriber;
}

- (void)sendNext:(id)value {
    if(_next) _next(value);
}

- (void)sendError:(NSError *)error {
    if (_error) ^{self->_error(error);}();
}

- (id)sendNextWithReturnValue:(id)value {
    if (_nextWithReturnValue) return _nextWithReturnValue(value);
    return nil;
}

- (void)sendComplete:(id)value {
    if (_complete) ^{self->_complete(value);self->_next = nil;self->_complete = nil;}();
}

- (id)sendCompleteWithReturnValue:(id)value {
    if (_completeWithReturnValue) return ^id{id returnValue = self->_completeWithReturnValue(value);self->_nextWithReturnValue = nil;self->_completeWithReturnValue = nil;
        return returnValue;}();
    return ^id{self->_nextWithReturnValue = nil;self->_completeWithReturnValue = nil;return nil;}();
}

@end
