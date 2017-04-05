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
    void(^message_block)(id value);
    dispatch_source_t _eventSource;
    id _currentValue;
}
+ (instancetype)subscriberWithMessage:(void(^)(id value))message
{
    SKSubscriber* subscriber = [SKSubscriber new];
    subscriber->message_block = [message copy];
    subscriber->_eventSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    @weakify(subscriber)
    dispatch_source_set_event_handler(subscriber->_eventSource, ^{
        @strongify(subscriber)
        if(subscriber->message_block) subscriber->message_block(subscriber->_currentValue);
    });
    dispatch_resume(subscriber->_eventSource);
    return subscriber;
}

- (void)sendMessage:(id)value
{
    _currentValue =  value;
    if(message_block) dispatch_source_merge_data(_eventSource, 1);
}

@end
