//
//  StreamObserver.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/29.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "StreamObserver.h"
#import "NSObject+StreamKit.h"
#import "SKSignal.h"

@implementation StreamObserver

- (instancetype)initWithObject:(id)object nilValue:(id)nilValue;
{
    self = [super init];
    if (self) {
        _object = object;
        _nilValue = nilValue;
    }
    return self;
}

- (void)setObject:(SKSignal*)object forKeyedSubscript:(NSString *)keyPath
{
    [object subscribe:^(id x) {
        [_object setValue:x?x:_nilValue forKeyPath:keyPath];
    }];
}

@end
