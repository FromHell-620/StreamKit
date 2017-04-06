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
}

+ (instancetype)subscriberWithMessage:(void(^)(id value))message
{
    SKSubscriber* subscriber = [SKSubscriber new];
    subscriber->message_block = [message copy];
    return subscriber;
}

- (void)sendMessage:(id)value
{
    if(message_block) message_block(value);
}

- (void)dealloc
{

}

@end
