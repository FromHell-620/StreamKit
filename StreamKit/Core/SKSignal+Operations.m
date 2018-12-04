//
//  SKSignal+Operations.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKSignal+Operations.h"
#import "SKSubscriber.h"
#import "SKScheduler.h"
#import "SKCompoundDisposable.h"
#import "SKSerialDisposable.h"
#import "SKObjectifyMarco.h"
#import "SKValueNil.h"
#import "SKBlockTrampoline.h"
#import "SKSubject.h"
#import "SKReplaySubject.h"
#import "SKMulticastConnection+Private.h"
#import "NSObject+SKDeallocating.h"
#import "NSInvocation+SKValues.h"
#import <objc/runtime.h>

NSString * const SKSignalErrorDomain = @"SKSignalErrorDomain";

const NSUInteger SKSignalErrorTimeout = 1;

@implementation SKSignal (Operations)

- (SKSignal *)doNext:(void (^)(id))next {
    NSCParameterAssert(next);
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        return [self subscribeNext:^(id x) {
            next(x);
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
    }];
}

- (SKSignal *)doError:(void (^)(NSError *))block {
    NSCParameterAssert(block);
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        return [self subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            block(error);
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
    }];
}

- (SKSignal *)doCompleted:(void (^)(void))block {
    NSCParameterAssert(block);
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        return [self subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            block();
            [subscriber sendCompleted];
        }];
    }];
}

- (SKSignal *)throttle:(NSTimeInterval)interval {
    return [self throttle:interval valuesPredicate:^BOOL(id x) {
        return YES;
    }];
}

- (SKSignal *)throttle:(NSTimeInterval)interval valuesPredicate:(BOOL (^)(id))predicate {
    NSCParameterAssert(predicate);
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKScheduler *scheduler = [SKScheduler subscriptionScheduler];
        SKCompoundDisposable *compoundDisposable = [SKCompoundDisposable disposableWithdisposes:nil];
        __block BOOL isExecuting = NO;
        void (^immediate)(id,BOOL) = ^ (id x,BOOL send) {
            @synchronized (compoundDisposable) {
                if (isExecuting == NO) isExecuting = YES;
                if (send) [subscriber sendNext:x];
            }
        };
        
        void (^prepareNext)(void) = ^ {
            @synchronized (compoundDisposable) {
                isExecuting = NO;
            }
        };
        
        SKDisposable *subscriberDisposable = [self subscribeNext:^(id x) {
            BOOL shouldThrottle = predicate(x);
            if (shouldThrottle) {
                if (isExecuting) return ;
                immediate(x,YES);
                [scheduler afterDelay:interval schedule:^{
                    prepareNext();
                }];
            }else {
                [subscriber sendNext:x];
            }
        } error:^(NSError *error) {
            [compoundDisposable dispose];
            [subscriber sendError:error];
        } completed:^{
            immediate(nil,NO);
            [subscriber sendCompleted];
        }];
        [compoundDisposable addDisposable:subscriberDisposable];
        return compoundDisposable;
    }];
}

- (SKSignal *)delay:(NSTimeInterval)interval {
    return [self delay:interval valuesPredicate:^BOOL(id x) {
        return YES;
    }];
}

- (SKSignal *)delay:(NSTimeInterval)interval valuesPredicate:(BOOL (^)(id))predicate {
    NSCParameterAssert(predicate);
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKScheduler *scheduler = [SKScheduler subscriptionScheduler];
        SKCompoundDisposable *compoundDisposable = [SKCompoundDisposable disposableWithdisposes:nil];
        __block NSInteger nextTimes = 0.0;
        
        void (^changeTimes)(BOOL,BOOL) = ^ (BOOL isConsume,BOOL shouldDelay) {
            @synchronized (compoundDisposable) {
                if (!shouldDelay) return ;
                if (isConsume) nextTimes -= interval;
                else nextTimes += interval;
            }
        };
        
        void (^immediate)(id,BOOL) = ^ (id x,BOOL shouldDelay) {
            @synchronized (compoundDisposable) {
                changeTimes(YES,shouldDelay);
                [subscriber sendNext:x];
            }
        };
        
        SKDisposable *subscriberDisposable = [self subscribeNext:^(id x) {
            BOOL shouldDelay = predicate(x);
            changeTimes(NO,shouldDelay);
            if (shouldDelay) {
                SKDisposable *schedulerDisposable = [scheduler afterDelay:interval schedule:^{
                    immediate(x,shouldDelay);
                }];
                [compoundDisposable addDisposable:schedulerDisposable];
            }else {
                immediate(x,shouldDelay);
            }
        } error:^(NSError *error) {
            [compoundDisposable dispose];
            [subscriber sendError:error];
        } completed:^{
            SKDisposable *completeDisposable = [scheduler afterDelay:nextTimes schedule:^{
                [subscriber sendCompleted];
            }];
            [compoundDisposable addDisposable:completeDisposable];
        }];
        [compoundDisposable addDisposable:subscriberDisposable];
        return compoundDisposable;
    }];
}

- (SKSignal *)catch:(SKSignal *(^)(NSError *))errorBlock {
    NSCParameterAssert(errorBlock);
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        __block SKDisposable *disposable = nil;
        SKDisposable *subscribeDisposable = [self subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            SKSignal *signal = errorBlock(error);
            disposable = [signal subscribe:subscriber];
        } completed:^{
            [subscriber sendCompleted];
        }];
        return [SKDisposable disposableWithBlock:^{
            [subscribeDisposable dispose];
            [disposable dispose];
        }];
    }];
}

- (SKSignal *)catchTo:(SKSignal *)signal {
    return [self catch:^SKSignal *(NSError *error) {
        return signal;
    }];
}

- (SKSignal *)initially:(dispatch_block_t)block {
    NSCParameterAssert(block);
    return [SKSignal defer:^SKSignal *{
        block();
        return self;
    }];
}

- (SKSignal *)finally:(dispatch_block_t)block {
    NSCParameterAssert(block);
    return [[self doError:^(NSError *error) {
        block();
    }] doCompleted:^{
        block();
    }];
}

+ (SKSignal *)defer:(SKSignal *(^)(void))block {
    NSCParameterAssert(block);
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        return [block() subscribe:subscriber];
    }];
}

- (SKSignal *)bufferWithTime:(NSTimeInterval)interval {
    return [self bufferWithTime:interval onScheduler:SKScheduler.subscriptionScheduler];
}

- (SKSignal *)bufferWithTime:(NSTimeInterval)interval onScheduler:(SKScheduler *)scheduler {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        NSMutableArray *buffer = [NSMutableArray array];
        SKSerialDisposable *schedulerDisposable = [[SKSerialDisposable alloc] init];
        void (^sendNext)(void) = ^ {
            @synchronized (buffer) {
                [schedulerDisposable.disposable dispose];
                NSArray *objcs = [buffer copy];
                [buffer removeAllObjects];
                [subscriber sendNext:objcs];
            }
        };
        SKDisposable *selfDisposable = [self subscribeNext:^(id x) {
            if (buffer.count == 0) {
                schedulerDisposable.disposable = [scheduler afterDelay:interval schedule:^{
                    sendNext();
                }];
            }
            if (x) [buffer addObject:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            sendNext();
            [subscriber sendCompleted];
        }];;
        return [SKDisposable disposableWithBlock:^{
            [selfDisposable dispose];
            [schedulerDisposable dispose];
        }];
    }];
}

- (SKSignal *)takeLast {
    return [self takeLast:1];
}

- (SKSignal *)takeLast:(NSInteger)count {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
        return [self subscribeNext:^(id x) {
            [values addObject:x ?: SKValueNil.ValueNil];
            if (values.count > count) [values removeObjectAtIndex:0];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            for (id obj in values) {
                [subscriber sendNext:obj == SKValueNil.ValueNil ? nil : obj];
            }
            [subscriber sendCompleted];
        }];
    }];
}

- (SKSignal *)combineLatestWithSignal:(SKSignal *)signal {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKCompoundDisposable *disposable = [SKCompoundDisposable disposableWithdisposes:nil];
        __block BOOL selfCompleted = NO;
        __block id selfValue = nil;
        __block BOOL otherCompleted = NO;
        __block id otherValue = nil;
        
        void (^sendNext)(void) = ^ {
            @synchronized (disposable) {
                if (selfValue == nil || otherValue == nil) return ;
                [subscriber sendNext:@[selfValue,otherValue]];
            }
        };
        SKDisposable *selfDisposable = [self subscribeNext:^(id x) {
            selfValue = x ?: SKValueNil.ValueNil;
            sendNext();
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            @synchronized (disposable) {
                selfCompleted = YES;
                if (otherCompleted) [subscriber sendCompleted];
            }
        }];
        
       SKDisposable *otherDisposable = [signal subscribeNext:^(id x) {
           otherValue = x ?: SKValueNil.ValueNil;
           sendNext();
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            @synchronized (disposable) {
                otherCompleted = YES;
                if (selfCompleted) [subscriber sendCompleted];
            }
        }];
        [disposable addDisposable:selfDisposable];
        [disposable addDisposable:otherDisposable];
        return disposable;
    }];
}

+ (SKSignal *)combineLatestWithSignals:(NSArray<SKSignal *> *)signals {
    return [self join:signals block:^SKSignal *(SKSignal * left, SKSignal *right) {
        return [left combineLatestWithSignal:right];
    }];
}

+ (SKSignal *)join:(NSArray<SKSignal *> *)signals block:(SKSignal *(^)(id, id))block {
    NSCParameterAssert(block);
    SKSignal *current = nil;
    for (SKSignal *signal in signals) {
        if (current == nil) {
            current = [signal map:^ (id x) {
                return x ? @[x] : @[SKValueNil.ValueNil];
            }];
            continue;
        }
        current = block(current,signal);
    }
    return [current map:^(NSArray *x) {
        NSMutableArray *values = [NSMutableArray array];
        while (x) {
            id value = x.lastObject;
            [values insertObject:value atIndex:0];
            if (x.count == 1) break;
            x = x.firstObject;
        }
        return values;
    }];
}

- (SKSignal*)flattenMap:(SKSignal *(^)(id value))block {
    NSCParameterAssert(block);
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        NSMutableArray *signals = [NSMutableArray arrayWithObject:self];
        SKCompoundDisposable *compoundDisposable = [SKCompoundDisposable disposableWithdisposes:nil];
        
        void (^completeSubscriber)(SKSignal *,SKDisposable *) = ^ (SKSignal *signal,SKDisposable *disposable) {
            @synchronized (compoundDisposable) {
                [signals removeObject:signal];
                if (signals.count == 0) {
                    [subscriber sendCompleted];
                    [compoundDisposable dispose];
                }else {
                    [compoundDisposable removeDisposable:disposable];
                }
            }
        };
        
        void (^subscribeSignal)(SKSignal *) = ^ (SKSignal *signal) {
            @synchronized (compoundDisposable) {
                [signals addObject:signal];
            }
            SKSerialDisposable *signalDisposable = [SKSerialDisposable new];
            [compoundDisposable addDisposable:signalDisposable];
            signalDisposable.disposable = [signal subscribeNext:^(id x) {
                [subscriber sendNext:x];
            } error:^(NSError *error) {
                [compoundDisposable dispose];
                [subscriber sendError:error];
            } completed:^{
                completeSubscriber(signal,signalDisposable);
            }];
        };
        SKSerialDisposable *selfDisposable = [SKSerialDisposable new];
        selfDisposable.disposable = [self subscribeNext:^(id x) {
            SKSignal *signal = block(x);
            if (signal) subscribeSignal(signal);
        } error:^(NSError *error) {
            [compoundDisposable dispose];
            [subscriber sendError:error];
        } completed:^{
            completeSubscriber(self,selfDisposable);
        }];
        [compoundDisposable addDisposable:selfDisposable];
        return compoundDisposable;
    }];
}

+ (SKSignal *)combineLatest:(NSArray<SKSignal *> *)signals reduce:(id (^)())reduceBlock {
    NSCParameterAssert(reduceBlock);
    SKSignal *signal = [self combineLatestWithSignals:signals];
    return [signal reduceEach:reduceBlock];
}

- (SKSignal *)map:(id(^)(id x))block {
    NSCParameterAssert(block);
    return [self flattenMap:^SKSignal *(id value) {
        return [SKSignal return:block(value)];
    }];
}

- (SKSignal *)mapReplace:(id)value {
    return [self map:^id(id x) {
        return value;
    }];
}

- (SKSignal *)reduceEach:(id (^)())block {
    NSCParameterAssert(block);
    return [self map:^id(NSArray *x) {
        NSCAssert([x isKindOfClass: NSArray.class], @"value must be NSArray");
        return [SKBlockTrampoline invokeBlock:block arguments:x];
    }];
}

- (SKSignal *)filter:(BOOL(^)(id x))block {
    Class class = self.class;
    return [self flattenMap:^SKSignal *(id value) {
        return block(value) == YES ? [class return:value] : [class empty];
    }];
}

- (SKSignal *)flatten {
    return [self flattenMap:^SKSignal *(id value) {
        return value;
    }];
}

- (SKSignal *)merge:(SKSignal *)signal {
    return [SKSignal merge:@[self,signal]];
}

+ (SKSignal *)merge:(NSArray<SKSignal *> *)signals {
    return [[SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        [signals enumerateObjectsUsingBlock:^(SKSignal * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [subscriber sendNext:obj];
        }];
        [subscriber sendCompleted];
        return nil;
    }] flatten];
}

- (SKSignal *)flatten:(NSInteger)maxConcurrent {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKCompoundDisposable *compoundDisposable = [SKCompoundDisposable disposableWithdisposes:nil];
        NSMutableArray *activeDiposables = [NSMutableArray array];
        //store self signal completed
        __block BOOL selfCompleted = NO;
        __block void (^subscribeSignal)(SKSignal *);
        __weak __block void (^refc)(SKSignal *);
        void (^sendCompletedIfNeed)(void) = ^ {
            @synchronized (compoundDisposable) {
                if (selfCompleted && activeDiposables.count == 0) {
                    [subscriber sendCompleted];
                    subscribeSignal = nil;
                }
            }
        };
        
        void (^subscribeCompleteIfNeedDispose)(SKDisposable *,BOOL) = ^ (SKDisposable *disposable,BOOL should) {
            @synchronized (compoundDisposable) {
                if (should) {
                    [disposable dispose];
                }
                [compoundDisposable removeDisposable:disposable];
                [activeDiposables removeObjectIdenticalTo:disposable];
            }
        };
        //store the spare signals
        NSMutableArray *signals = [NSMutableArray array];
        
        SKSerialDisposable *subscribeDisposable = [SKSerialDisposable new];
        [compoundDisposable addDisposable:subscribeDisposable];
        refc = subscribeSignal = ^ (SKSignal *signal) {
            subscribeDisposable.disposable = [signal subscribeNext:^(id x) {
                [subscriber sendNext:x];
            } error:^(NSError *error) {
                subscribeCompleteIfNeedDispose(subscribeDisposable,YES);
            } completed:^{
                __strong void (^subscribeSignal)(SKSignal *) = refc;
                SKSignal *next;
                @synchronized (compoundDisposable) {
                    if (signals.count > 0) {
                        next = signals.firstObject;
                        [signals removeObjectAtIndex:0];
                    }
                }
                subscribeCompleteIfNeedDispose(subscribeDisposable,NO);

                if (signals.count == 0) {
                    sendCompletedIfNeed();
                    return ;
                }
                //recursion subscribe
                subscribeSignal(next);
            }];
        };
        SKDisposable *selfDisposable = [self subscribeNext:^(id x) {
            NSCAssert([x isKindOfClass:SKSignal.class], @"must be SKSignal");
            if (maxConcurrent > 0 && activeDiposables.count >= maxConcurrent) {
                [signals addObject:x];
                return ;
            }
            subscribeSignal(x);
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            selfCompleted = YES;
            sendCompletedIfNeed();
        }];
        [compoundDisposable addDisposable:selfDisposable];
        return compoundDisposable;
    }];
}

- (SKSignal *)concat {
    return [self flatten:1];
}

- (SKSignal *)concat:(SKSignal *)signal {
    NSCParameterAssert(signal);
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKSerialDisposable *disposable = [SKSerialDisposable new];
        disposable.disposable = [self subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            disposable.disposable = [signal subscribe:subscriber];
        }];
        return disposable;
    }];
}

+ (SKSignal *)concat:(NSArray<SKSignal *> *)signals {
    SKSignal *current = signals.firstObject;
    for (SKSignal *signal in signals) {
        if (current == signal) continue;
        current = [current concat:signal];
    }
    return current;
}

+ (id)interval:(NSTimeInterval)interval {
    return [self interval:interval onScheduler:[SKScheduler mainThreadScheduler] withLeeway:0.0];
}

+ (id)interval:(NSTimeInterval)interval onScheduler:(id)scheduler {
    return [self interval:interval onScheduler:scheduler withLeeway:0.0];
}

+ (SKSignal *)interval:(NSTimeInterval)interval onScheduler:(SKScheduler *)scheduler withLeeway:(NSTimeInterval)leeway {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        return [scheduler afterDelay:0 repeating:interval withLeeway:leeway schedule:^{
            [subscriber sendNext:[NSDate date]];
        }];
    }];
}

- (SKSignal *)takeUntil:(SKSignal *)other {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKCompoundDisposable *compoundDisposable = [SKCompoundDisposable disposableWithdisposes:nil];
        void (^sendCompleted)(void) = ^ {
            [compoundDisposable dispose];
            [subscriber sendCompleted];
        };
        
        SKDisposable *selfDisposable = [self subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            sendCompleted();
        }];
        [compoundDisposable addDisposable:selfDisposable];
        
        SKDisposable *otherDisposable = [other subscribeNext:^(id x) {
            sendCompleted();
        } error:^(NSError *error) {
            sendCompleted();
        } completed:^{
            sendCompleted();
        }];
        [compoundDisposable addDisposable:otherDisposable];
        return compoundDisposable;
    }];
}

- (SKSignal *)takeUntilReplacement:(SKSignal *)replacement {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        __block SKSerialDisposable *selfDisposable = [SKSerialDisposable new];
        void (^competedSelf)(void) = ^ {
            [selfDisposable dispose];
            @synchronized (subscriber) {
                selfDisposable = nil;
            }
        };
        selfDisposable.disposable = [[self concat:[SKSignal nerver]] subscribe:subscriber];
        SKDisposable *disposable = [replacement subscribeNext:^(id x) {
            competedSelf();
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            competedSelf();
            [subscriber sendError:error];
        } completed:^{
            competedSelf();
            [subscriber sendCompleted];
        }];
        return [SKDisposable disposableWithBlock:^{
            [selfDisposable dispose];
            [disposable dispose];
        }];
    }];
}

- (SKSignal *)startWith:(id)value {
    return [[SKSignal return:value] concat:self];
}

- (SKSignal *)ignore:(id)value {
    return [self filter:^BOOL(id x) {
        return x == value || [x isEqual:value];
    }];
}

- (SKSignal *)ignoreValues {
    return [self filter:^BOOL(id x) {
        return NO;
    }];
}

- (SKSignal *)aggregateWithStart:(id)startValue reduceBlock:(id (^)(id, id))block {
    NSCParameterAssert(block);
    return [self aggregateWithStart:startValue withIndexReduceBlock:^id(id running, id next, NSInteger index) {
        return block(running,next);
    }];
}

- (SKSignal *)aggregateWithStart:(id)startValue withIndexReduceBlock:(id (^)(id, id, NSInteger))block {
    NSCParameterAssert(block);
    return [[self scanWithStart:startValue withIndexReduceBlock:^id(id running, id next, NSInteger index) {
        return block(running,next,index);
    }] takeLast:1];
}

- (SKSignal *)scanWithStart:(id)startValue reduceBlock:(id (^)(id, id))block {
    NSCParameterAssert(block);
    return [self scanWithStart:startValue withIndexReduceBlock:^id(id running, id next, NSInteger index) {
        return block(running,next);
    }];
}

- (SKSignal *)scanWithStart:(id)startValue withIndexReduceBlock:(id (^)(id, id, NSInteger))block {
    NSCParameterAssert(block);
    __block id running = startValue;
    __block NSInteger index = 0;
    return [self flattenMap:^SKSignal *(id value) {
        running = block(running,block,index ++);
        return [SKSignal return:running];
    }];
}

- (id)first {
    return [self firstWithDefault:nil];
}

- (id)firstWithDefault:(id)defaultValue {
    __block id value = defaultValue;
    dispatch_semaphore_t lock = dispatch_semaphore_create(0);
   [[self take:1] subscribeNext:^(id x) {
        value = x;
        dispatch_semaphore_signal(lock);
    } error:^(NSError *error) {
        dispatch_semaphore_signal(lock);
    } completed:^{
        dispatch_semaphore_signal(lock);
    }];
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    return value;
}

- (SKSignal *)collect {
    return [self scanWithStart:[NSMutableArray array] reduceBlock:^id(NSMutableArray *running, id next) {
        [running addObject:next ? : NSNull.null];
        return running;
    }];
}

- (SKSignal *)combinePreviousWithStart:(id)start reduce:(id (^)(id, id))reduceBlock {
    NSCParameterAssert(reduceBlock);
    return [[self scanWithStart:@[start ?: SKValueNil.ValueNil] reduceBlock:^id(NSArray *running, id next) {
        id value = reduceBlock(running[0],next);
        return @[next ?: SKValueNil.ValueNil,value ?: SKValueNil.ValueNil];
    }] map:^id(NSArray *x) {
        return x.lastObject;
    }];
}

- (SKSignal *)zipWith:(SKSignal *)other {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKCompoundDisposable *compoundDisposable = [SKCompoundDisposable disposableWithdisposes:nil];
        __block BOOL selfCompleted = NO;
        NSMutableArray *selfValues = [NSMutableArray array];
        __block BOOL otherCompleted = NO;
        NSMutableArray *otherValues = [NSMutableArray array];
        
        void (^sendCompletedIfNeed)(void) = ^ {
            @synchronized (selfValues) {
                BOOL shouldCompletedSelf = selfCompleted || selfValues.count == 0;
                BOOL shouldCompletedOther = otherCompleted || otherValues.count == 0;
                if (shouldCompletedSelf || shouldCompletedOther) [subscriber sendCompleted];
            }
        };
        
        void (^sendNext)(void) = ^ {
            @synchronized (selfValues) {
                if (selfValues.count == 0 || otherValues.count == 0) return ;
                NSArray *values = @[selfValues.firstObject,otherValues.firstObject];
                [selfValues removeObjectAtIndex:0];
                [otherValues removeObjectAtIndex:0];
                [subscriber sendNext:values];
                sendCompletedIfNeed();
            }
        };
        
        void (^addValue)(id,BOOL) = ^ (id x,BOOL isSelf) {
            @synchronized (selfValues) {
                NSMutableArray *values = isSelf ? selfValues : otherValues;
                [values addObject:x ? : SKValueNil.ValueNil];
            }
            sendNext();
        };
        
        SKDisposable *selfDisposable = [self subscribeNext:^(id x) {
            addValue(x,YES);
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            @synchronized (selfValues) {
                selfCompleted = YES;
            }
            sendCompletedIfNeed();
        }];
        [compoundDisposable addDisposable:selfDisposable];
        
        SKDisposable *otherDisposable = [other subscribeNext:^(id x) {
            addValue(x,NO);
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            @synchronized (selfValues) {
                otherCompleted = YES;
            }
            sendCompletedIfNeed();
        }];
        [compoundDisposable addDisposable:otherDisposable];
        return compoundDisposable;
    }];
}

+ (SKSignal *)zip:(NSArray<SKSignal *> *)signals {
    return [self join:signals block:^SKSignal *(SKSignal *left, SKSignal *right) {
        return [left zipWith:right];
    }];
}

+ (SKSignal *)zip:(NSArray<SKSignal *> *)signals reduce:(id (^)())block {
    NSCParameterAssert(block);
    SKSignal *signal = [SKSignal zip:signals];
    signal = [signal reduceEach:block];
    return signal;
}

- (SKSignal *)distinctUntilChanged {
    __block id prveValue = nil;
    __block BOOL first = YES;
    return [self flattenMap:^SKSignal *(id value) {
        if ((!first && prveValue == value) || [prveValue isEqual:value]) return SKSignal.empty;
        prveValue = value;
        return [SKSignal return:value];
    }];
}

- (SKSignal *)take:(NSUInteger)takes {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKSerialDisposable *serialDisposable = [SKSerialDisposable new];
        __block NSUInteger taked = 0;
        void (^sendNext)(id) = ^ (id value) {
            @synchronized (serialDisposable) {
                ++taked;
                [subscriber sendNext:value];
                if (taked == takes) {
                    [serialDisposable dispose];
                }
            }
        };
        SKDisposable *selfDisposable = [self subscribeNext:^(id x) {
            if (taked < takes) sendNext(x);
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
        serialDisposable.disposable = selfDisposable;
        return serialDisposable;
    }];
}

- (SKSignal *)takeUntilBlock:(BOOL(^)(id x))block {
    NSCParameterAssert(block);
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKSerialDisposable *selfDisposable = [SKSerialDisposable new];
        selfDisposable.disposable = [self subscribeNext:^(id x) {
            if (block(x)) [selfDisposable dispose];
            else [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
        return selfDisposable;
    }];
}

- (SKSignal *)takeWhileBlock:(BOOL(^)(id x))block {
    return [self takeUntilBlock:^BOOL(id x) {
        return !block(x);
    }];
}

- (SKSignal *)skip:(NSUInteger)takes {
    __block NSUInteger skipCount = 0;
    return [self flattenMap:^SKSignal *(id value) {
        if (skipCount >= takes) return [SKSignal return:value];
        skipCount ++;
        return SKSignal.empty;
    }];
}

- (SKSignal *)skipUntilBlock:(BOOL(^)(id x))block {
    NSCParameterAssert(block);
    __block BOOL skiped = YES;
    return [self flattenMap:^SKSignal *(id value) {
        if (skiped) {
            if (block(value)) {
                skiped = NO;
            }else
                return SKSignal.empty;
        }
        return [SKSignal return:value];
    }];
}

- (SKSignal *)skipWhileBlock:(BOOL(^)(id x))block {
    NSCParameterAssert(block);
    return [self skipUntilBlock:^BOOL(id x) {
        return !block(x);
    }];
}

- (SKSignal *)Y {
    return [self map:^id(id x) {
        return @(YES);
    }];
}

- (SKSignal *)N {
    return [self map:^id(id x) {
        return @(NO);
    }];
}

- (SKSignal *)not {
    return [self map:^id(NSNumber *x) {
        NSCAssert([x isKindOfClass:NSNumber.class], @"-not must only be used on a signal of NSNumbers. Instead, got: %@", x);
        return @(!x.boolValue);
    }];
}

- (SKSignal *)scheduleOn:(SKScheduler *)scheduler {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKCompoundDisposable *compoundDisposable = [SKCompoundDisposable disposableWithdisposes:nil];
        SKDisposable *selfDisposable = [self subscribeNext:^(id x) {
            [compoundDisposable addDisposable:[scheduler schedule:^{
                [subscriber sendNext:x];
            }]];
        } error:^(NSError *error) {
            [compoundDisposable addDisposable:[scheduler schedule:^{
                [subscriber sendError:error];
            }]];
        } completed:^{
            [compoundDisposable addDisposable:[scheduler schedule:^{
                [subscriber sendCompleted];
            }]];
        }];
        [compoundDisposable addDisposable:selfDisposable];
        return compoundDisposable;
    }];
}

- (SKMulticastConnection *)publish {
    return [self multicast:SKSubject.subject];
}

- (SKMulticastConnection *)multicast:(SKSubject *)subject {
    return [[SKMulticastConnection alloc] initWithSourceSignal:self subject:subject];
}

- (SKSignal *)replay {
    SKMulticastConnection *connection = [self multicast:SKSubject.subject];
    [connection connect];
    return connection.signal;
}

- (SKSignal *)replayLast {
    SKMulticastConnection *connection = [self multicast:[SKReplaySubject subjectWithCapacity:1]];
    [connection connect];
    return connection.signal;
}

- (SKSignal *)timeout:(NSTimeInterval)interval {
    return [self timeout:interval onScheduler:[SKScheduler mainThreadScheduler]];
}

- (SKSignal *)timeout:(NSTimeInterval)interval onScheduler:(SKScheduler *)scheduler {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKCompoundDisposable *disposable = [SKCompoundDisposable compoundDisposable];
        SKDisposable *schedulerDisposable = [scheduler afterDelay:interval schedule:^{
            [disposable dispose];
            [subscriber sendError:[NSError errorWithDomain:SKSignalErrorDomain code:SKSignalErrorTimeout userInfo:nil]];
        }];
        [disposable addDisposable:schedulerDisposable];
        SKDisposable *subscriberDisposable = [self subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [disposable dispose];
            [subscriber sendError:error];
        } completed:^{
            [disposable dispose];
            [subscriber sendCompleted];
        }];
        [disposable addDisposable:subscriberDisposable];
        return disposable;
    }];
}

- (SKDisposable *)setKeyPath:(NSString *)keyPath onObject:(id)onObject {
    return [self setKeyPath:keyPath onObject:onObject nilValue:nil];
}

- (SKDisposable *)setKeyPath:(NSString *)keyPath onObject:(NSObject *)onObject nilValue:(id)nilValue {
    NSParameterAssert(keyPath);
    NSParameterAssert(onObject);
    keyPath = [keyPath copy];
    __block void *volatile objPtr = (__bridge void *)onObject;
    SKCompoundDisposable *compoundDisposable = [SKCompoundDisposable compoundDisposable];
    SKDisposable *subscriberDisposable = [self subscribeNext:^(id x) {
        __strong NSObject *objc __attribute__((objc_precise_lifetime)) = (__bridge __strong id)objPtr;
        [objc setValue:x?:nilValue forKeyPath:keyPath];
    } error:^(NSError *error) {
        __unused __strong NSObject *objc __attribute((objc_precise_lifetime)) = (__bridge __strong id)objPtr;
        NSCAssert(NO, @"SKSignal receive a error When binding keyPath %@ on object %@",keyPath,objc);
        [compoundDisposable dispose];
    } completed:^{
        [compoundDisposable dispose];
    }];
    [compoundDisposable addDisposable:subscriberDisposable];
    
#ifdef DEBUG
    static const void * const SKKeyPathBindingKey = &SKKeyPathBindingKey;
    NSMutableDictionary *bindKeys;
    @synchronized (compoundDisposable) {
        bindKeys = objc_getAssociatedObject(onObject, SKKeyPathBindingKey);
        if (bindKeys == nilValue) {
            bindKeys = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(onObject, SKKeyPathBindingKey, bindKeys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    @synchronized (compoundDisposable) {
        __unsafe_unretained id bindValue = bindKeys[keyPath];
        NSCAssert(bindValue == nil, @"This object %@ has alreald bind a same keypath %@ on itself",onObject,keyPath);
        [bindKeys setObject:[NSValue valueWithNonretainedObject:self] forKey:keyPath];
    }
#endif
    
    SKDisposable *cleanPointerDisposable = [SKDisposable disposableWithBlock:^{
#ifdef DEBUG
        @synchronized (compoundDisposable) {
            [bindKeys removeObjectForKey:keyPath];
        }
#endif
        @synchronized (compoundDisposable) {
            objPtr = NULL;
        }
    }];
    [compoundDisposable addDisposable:cleanPointerDisposable];
    [onObject.deallocDisposable addDisposable:compoundDisposable];
    return [SKDisposable disposableWithBlock:^{
        [onObject.deallocDisposable removeDisposable:compoundDisposable];
        [compoundDisposable dispose];
    }];
}

- (SKDisposable *)invokeAction:(SEL)selector onTarget:(id)target {
    SKSerialDisposable *disposable = [SKSerialDisposable new];
    __block void *volatile objPtr = (__bridge void *)target;
     disposable.disposable = [self subscribeNext:^(id x) {
         __strong NSObject *objc __attribute__((objc_precise_lifetime)) = (__bridge __strong id)objPtr;
         NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[objc methodSignatureForSelector:selector]];
         invocation.target = objc;
         invocation.selector = selector;
         if (!x || invocation.methodSignature.numberOfArguments == 2) {
             // do nothing
             while (0) {}
         }else if (![x isKindOfClass:NSArray.class]) {
             [invocation sk_setArgmentWithValue:x atIndex:2];
         }else {
             [x enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 *stop = idx + 2 > invocation.methodSignature.numberOfArguments;
                 if (*stop == YES) return ;
                 [invocation sk_setArgmentWithValue:obj atIndex:idx + 2];
             }];
         }
         [invocation invoke];
    } error:^(NSError *error) {
        [disposable dispose];
    } completed:^{
        [disposable dispose];
    }];
    return disposable;
}

- (SKSignal *)switchToLatest {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKMulticastConnection *connection = [self publish];
        SKDisposable *subscriberDisposable = [[connection.signal flattenMap:^SKSignal *(SKSignal *value) {
            NSCAssert([value isKindOfClass:SKSignal.class], @"SwitchToLatest must receive signal");
            return [value takeUntil:[connection.signal concat:[SKSignal nerver]]];//ignore completed event
        }] subscribe:subscriber];
        SKDisposable *connectDisposable = [connection connect];
        return [SKDisposable disposableWithBlock:^{
            [subscriberDisposable dispose];
            [connectDisposable dispose];
        }];
    }];
}

+ (SKSignal *)if:(SKSignal *)boolSignal then:(SKSignal *)trueSignal else:(SKSignal *)falseSignal {
    return [[boolSignal map:^id(NSNumber *x) {
        NSCAssert([x isKindOfClass:NSNumber.class], @"if operaiton boolSignal must send bool value");
        return x.boolValue ? trueSignal : falseSignal;
    }] switchToLatest];
}

@end
