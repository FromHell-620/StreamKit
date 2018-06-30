//
//  NSInvocation+SKValues.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/30.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "NSInvocation+SKValues.h"
#import "SKValueNil.h"

@implementation NSInvocation (SKValues)

- (NSArray *)sk_values {
    NSInteger argmentCount = self.methodSignature.numberOfArguments;
    NSMutableArray *values = NSMutableArray.new;
    for (NSInteger i = 2; i < argmentCount; i ++) {
        [values addObject:[self sk_argmentWithIndex:i] ? : SKValueNil.ValueNil];
    }
    return values.new;
}

- (id)sk_argmentWithIndex:(NSInteger)index {
    return nil;
}

@end
