//
//  SKCommand.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/5/21.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKCommand.h"
#import "SKSignal.h"
#import "SKSubscriber.h"

@interface SKCommand ()

@property (nonatomic,copy) SKSignal *(^signalBlock)(id x);

@property (nonatomic,strong) NSMutableArray<SKSignal *> *activeExecutionSignals;

@end

@implementation SKCommand

- (NSMutableArray<SKSignal *> *)activeExecutionSignals {
    if (!_activeExecutionSignals) {
        _activeExecutionSignals = [NSMutableArray array];
    }
    return _activeExecutionSignals;
}

//- (void)add

- (instancetype)initWithSignalBlock:(SKSignal *(^)(id))signalBlock {
    return [self initWithEnabled:nil signalBlock:signalBlock];
}

- (instancetype)initWithEnabled:(SKSignal *)enabled signalBlock:(SKSignal *(^)(id))signalBlock {
    NSCParameterAssert(signalBlock);
    self = [super init];
    if (self) {
        self.signalBlock = signalBlock;
        _enabledSignal = enabled;
    }
    return self;
}

- (void)execute:(id)value {
    __block BOOL enable = YES;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.enabledSignal subscribeNext:^(NSNumber *x) {
        NSCAssert([x isKindOfClass:NSNumber.class], @"-not must only be used on a signal of NSNumbers. Instead, got: %@", x);
        enable = x.boolValue;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    if (enable == NO) return ;
    
    SKSignal *signal = self.signalBlock(value);
    NSParameterAssert(signal);
    [self.activeExecutionSignals addObject:signal];
}

@end
