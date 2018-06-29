//
//  SKDelegatePoxy.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/29.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKDelegateProxy.h"

@implementation SKDelegateProxy {
    Protocol *_protocol;
}

- (instancetype)initWithProtocol:(Protocol *)protocol {
    self = [super init];
    if (self) {
        _protocol = protocol;
    }
    return self;
}

@end
