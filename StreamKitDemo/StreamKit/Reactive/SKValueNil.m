//
//  SKValueNil.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/18.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKValueNil.h"

@implementation SKValueNil

+ (instancetype)ValueNil {
    static SKValueNil *value = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        value = [SKValueNil new];
    });
    return value;
}



- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    return self;
}

@end
