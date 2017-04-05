//
//  SKSignal.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/31.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSignal.h"

@implementation SKSignal {
    id _block;
}

+ (instancetype)signalWithBlock:(void(^)(id value))block
{
    SKSignal* signal = [SKSignal new];
    signal->_block = [block copy];
    return signal;
}

- (SKSignal*)map:(id)block
{
    return [SKSignal signalWithBlock:^(id value) {
        
    }];
}

@end
