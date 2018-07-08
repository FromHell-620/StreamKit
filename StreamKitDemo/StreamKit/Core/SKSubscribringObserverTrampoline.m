//
//  StreamObserver.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/29.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSubscribringObserverTrampoline.h"
#import "SKSignal.h"
#import "SKSignal+Operations.h"

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

- (void)setObject:(SKSignal*)signal forKeyedSubscript:(NSString *)keyPath
{
    [signal setKeyPath:keyPath onObject:self.object nilValue:self.nilValue];
}

@end
