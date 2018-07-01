//
//  StreamObserver.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/29.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSubscribringObserverTrampoline.h"
#import "SKSignal.h"

@implementation SKSubscribringObserverTrampoline

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
    [object subscribeNext:^(id x) {
        [self->_object setValue:x?x:self->_nilValue forKeyPath:keyPath];
    }];
}

@end
