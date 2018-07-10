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
#import <libkern/OSAtomic.h>
#import "SKKeyPathMarco.h"
#import "SKMetaMarco.h"
#import "SKObjectifyMarco.h"

@interface SKCommand (){
    volatile uint32_t _allowConcurrentExecute;
}

@property (nonatomic,copy) SKSignal *(^signalBlock)(id x);

@property (nonatomic,strong) NSMutableArray<SKSignal *> *activeExecutionSignals;

@end

@implementation SKCommand

- (BOOL)allowConcurrentExecute {
    return _allowConcurrentExecute != 0;
}

- (void)setAllowConcurrentExecute:(BOOL)allowConcurrentExecute {
    [self willChangeValueForKey:@sk_keypath(self,allowConcurrentExecute)];
    if (allowConcurrentExecute) {
        OSAtomicOr32Barrier(1, &_allowConcurrentExecute);
    }else {
        OSAtomicAnd32Barrier(0, &_allowConcurrentExecute);
    }
    [self didChangeValueForKey:@sk_keypath(self,allowConcurrentExecute)];
}

- (NSMutableArray<SKSignal *> *)activeExecutionSignals {
    if (!_activeExecutionSignals) {
        _activeExecutionSignals = [NSMutableArray array];
    }
    return _activeExecutionSignals;
}

- (void)addActiveExecutionSignal:(SKSignal *)signal {
    @synchronized (self) {
        NSIndexSet *indexs = [NSIndexSet indexSetWithIndex:_activeExecutionSignals.count];
        [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexs forKey:@sk_keypath(self,activeExecutionSignals)];
        [self.activeExecutionSignals addObject:signal];
        [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexs forKey:@sk_keypath(self,activeExecutionSignals)];
    }
}

- (void)removeActiveExecutionSignal:(SKSignal *)signal {
    @synchronized (self) {
        NSIndexSet *indexs = [self.activeExecutionSignals indexesOfObjectsPassingTest:^BOOL(SKSignal * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return obj == signal;
        }];
        if (indexs.count == 0) return;
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexs forKey:@sk_keypath(self,activeExecutionSignals)];
        [self.activeExecutionSignals removeObjectsAtIndexes:indexs];
        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexs forKey:@sk_keypath(self,activeExecutionSignals)];
    }
}

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
