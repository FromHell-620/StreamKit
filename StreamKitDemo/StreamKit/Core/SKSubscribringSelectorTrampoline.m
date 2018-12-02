//
//  SKSubscribringSelectorTrampoline.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/12/2.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKSubscribringSelectorTrampoline.h"
#import "SKSignal+Operations.h"

@implementation SKSubscribringSelectorTrampoline

- (instancetype)initWithTarget:(id)target {
    self = [super init];
    if (self) {
        _target = target;
    }
    return self;
}

- (void)setObject:(SKSignal *)object forKeyedSubscript:(NSString *)keyPath {
    [object invokeAction:sel_registerName(keyPath.UTF8String) onTarget:self.target];
}

@end
