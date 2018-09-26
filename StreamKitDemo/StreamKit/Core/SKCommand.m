//
//  SKCommand.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/5/21.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKCommand.h"
#import "SKSignal.h"
#import "SKSignal+Operations.h"
#import "NSObject+SKObservering.h"
#import "NSObject+SKDeallocating.h"
#import "SKReplaySubject.h"
#import "SKSubscriber.h"
#import <libkern/OSAtomic.h>
#import "SKMulticastConnection.h"
#import "SKKeyPathMarco.h"
#import "SKMetaMarco.h"
#import "SKObjectifyMarco.h"
#import "SKScheduler.h"

@interface SKCommand (){
    volatile uint32_t _allowConcurrentExecute;
}

@property (nonatomic,copy) SKSignal *(^signalBlock)(id x);

@property (nonatomic,strong) NSMutableArray<SKSignal *> *activeExecutionSignals;

@property (nonatomic,strong) SKSignal *immediateEnabled;

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
        
        SKSignal *newAcitveSignals = [[[[SKObserve(self,activeExecutionSignals)  map:^id( NSArray *x) {
            return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
                [x enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [subscriber sendNext:obj];
                }];
                [subscriber sendCompleted];
                return nil;
            }];
        }]concat]publish]autoConnect]   ;
        
        _executeSignals = [[newAcitveSignals map:^id(SKSignal *x) {
            return [x catchTo:[SKSignal empty]];
        }] scheduleOn:[SKScheduler mainThreadScheduler]];
//
        SKMulticastConnection *errorConnection = [[[newAcitveSignals flattenMap:^SKSignal *(SKSignal *value) {
            return [[value ignoreValues] catch:^SKSignal *(NSError *error) {
                return [SKSignal return:error];
            }];
        }] scheduleOn:[SKScheduler mainThreadScheduler]] publish];
        _errorSignal = errorConnection.signal;
        [errorConnection connect];

        SKSignal *onExecuteing = [SKObserve(self,activeExecutionSignals) map:^id(NSArray *x) {
            return @(x.count > 0);
        }];

        __unused SKSignal *moreExecutionsAllowed = [SKSignal if:SKObserve(self,allowConcurrentExecute) then:[SKSignal return:@(YES)] else:onExecuteing.not];
        if (enabled == nil) {
            enabled = [SKSignal return:@(YES)];
        }else {
            enabled = [[[enabled startWith:@(YES)] takeUntil:self.deallocSignal] replayLast];
        }
        _immediateEnabled = enabled;
//        _immediateEnabled = [SKSignal combineLatest:@[enabled,moreExecutionsAllowed] reduce:^(NSNumber* x,NSNumber *y){
//            return @(x.boolValue && y.boolValue);
//        }];
        _enabledSignal = [[[_immediateEnabled distinctUntilChanged] scheduleOn:[SKScheduler mainThreadScheduler]] replayLast];
    }
    return self;
}

- (SKSignal *)execute:(id)value {
    BOOL enabled = self.allowConcurrentExecute == NO ? self.activeExecutionSignals.count == 0 : YES;
    if (enabled == NO) {
        return nil;
    }
    
    SKSignal *signal = self.signalBlock(value);
    NSParameterAssert(signal);
    SKMulticastConnection *connection = [[signal scheduleOn:[SKScheduler mainThreadScheduler]] multicast:[SKReplaySubject subject]];
    [self addActiveExecutionSignal:connection.signal];
    @weakify(self)
    [connection.signal subscribeNext:nil error:^(NSError *error) {
        @strongify(self)
        [self removeActiveExecutionSignal:connection.signal];
    } completed:^{
        @strongify(self)
        [self removeActiveExecutionSignal:connection.signal];
    }];
    [connection connect];
    return connection.signal;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    // Generate all KVO notifications manually to avoid the performance impact
    // of unnecessary swizzling.
    return NO;
}

@end
