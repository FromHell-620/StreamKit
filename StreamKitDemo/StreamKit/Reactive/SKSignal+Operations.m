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
        __block SKCompoundDisposable *throttleDisposable = [SKCompoundDisposable disposableWithBlock:nil];
        [compoundDisposable addDisposable:throttleDisposable];
        @unsafeify(compoundDisposable,throttleDisposable)
        [throttleDisposable addDisposable:[SKDisposable disposableWithBlock:^{
            @strongify(compoundDisposable,throttleDisposable)
            [compoundDisposable removeDisposable:throttleDisposable];
        }]];
        void (^throttleDipose)(void) = ^{
            [throttleDisposable dispose];
            throttleDisposable = [SKCompoundDisposable disposableWithBlock:nil];
            [throttleDisposable addDisposable:[SKDisposable disposableWithBlock:^{
                @strongify(compoundDisposable,throttleDisposable)
                [compoundDisposable removeDisposable:throttleDisposable];
            }]];
            [compoundDisposable addDisposable:throttleDisposable];
        };
        
        void (^immediate)(id,BOOL) = ^ (id x,BOOL send) {
            @synchronized (compoundDisposable) {
                throttleDipose();
                if (send) [subscriber sendNext:x];
            }
        };
        
        SKDisposable *subscriberDisposable = [self subscribeNext:^(id x) {
            BOOL shouldThrottle = predicate(x);
            if (shouldThrottle) {
                SKDisposable *schedulerDisposable = [scheduler afterDelay:interval schedule:^{
                    immediate(x,YES);
                }];
                [throttleDisposable addDisposable:schedulerDisposable];
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
            if (x) [values addObject:x];
            if (values.count > count) [values removeObjectAtIndex:0];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            for (id obj in values) {
                [subscriber sendNext:obj];
            }
            [subscriber sendCompleted];
        }];
    }];
}

- (SKSignal *)combineLatestWithSignal:(SKSignal *)signal {
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        SKCompoundDisposable *disposable = [SKCompoundDisposable disposableWithdisposes:nil];
        __block BOOL selfCompleted = NO;
        __block id selfValue = SKValueNil.ValueNil;
        __block BOOL otherCompleted = NO;
        __block id otherValue = SKValueNil.ValueNil;
        
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
            x = x.firstObject;
        }
        return values;
    }];
}

- (SKSignal*)flattenMap:(SKSignal *(^)(id value))block {
    NSCParameterAssert(block);
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        NSMutableArray *signals = [NSMutableArray array];
        SKCompoundDisposable *compoundDisposable = [SKCompoundDisposable disposableWithdisposes:nil];
        
        void (^completeSubscriber)(SKSignal *,SKDisposable *) = ^ (SKSignal *signal,SKDisposable *completeDisposable) {
            @synchronized (compoundDisposable) {
                [signals removeObject:signal];
                if (signals.count == 0) {
                    [subscriber sendCompleted];
                    [compoundDisposable dispose];
                }else {
                    [compoundDisposable removeDisposable:compoundDisposable];
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

+ (SKSignal *)combineLatest:(NSArray<SKSignal *> *)signals reduce:(id (^)(id, ...))reduceBlock {
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

- (SKSignal *)reduceEach:(id (^)(id, ...))block {
    NSCParameterAssert(block);
    return [self map:^id(NSArray *x) {
        NSAssert([x isKindOfClass: NSArray.class], @"value must be NSArray");
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
            NSAssert([x isKindOfClass:SKSignal.class], @"must be SKSignal");
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

- (SKSignal *)ignore:(id)value {
    return [self filter:^BOOL(id x) {
        return [x isEqual:value];
    }];
}

- (SKSignal *)takeUntil:(SKSignal *)signal {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [signal subscribeNext:^(id x) {
            [subscriber sendComplete:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
        
        [self subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

- (SKSignal *)distinctUntilChanged {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        __block id pre_value = nil;
        [self subscribeNext:^(id x) {
            if (!(pre_value == x || [pre_value isEqual:x])) {
                pre_value = x;
                [subscriber sendNext:x];
            }
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

- (SKSignal *)take:(NSUInteger)takes {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        __block NSUInteger already_takes = 0;
        [self subscribeNext:^(id x) {
            if (already_takes < takes) {
                [subscriber sendNext:x];
            }
            already_takes ++;
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

- (SKSignal *)takeUntilBlock:(BOOL(^)(id x))block {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribeNext:^(id x) {
            if (block(x) == NO ) {
                [subscriber sendNext:x];
            }else
                [subscriber sendComplete:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

- (SKSignal *)takeWhileBlock:(BOOL(^)(id x))block {
    return [self takeUntilBlock:^BOOL(id x) {
        return !block(x);
    }];
}

- (SKSignal *)skip:(NSUInteger)takes {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        __block NSUInteger already = 0;
        [self subscribeNext:^(id x) {
            already ++;
            if (already > takes) {
                [subscriber sendNext:x];
            }
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

- (SKSignal *)skipUntilBlock:(BOOL(^)(id x))block {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribeNext:^(id x) {
            if (block(x) == YES) {
                [subscriber sendNext:x];
            }
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

- (SKSignal *)skipWhileBlock:(BOOL(^)(id x))block {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribeNext:^(id x) {
            if (block(x) == NO) {
                [subscriber sendNext:x];
            }
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

- (SKSignal *)startWith:(id)value {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [subscriber sendNext:value];
        [self subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

- (SKSignal *)startWithBlock:(void (^)(id))block {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        __block BOOL execute = YES;
        [self subscribeNext:^(id x) {
            if (execute) {block(x);execute = NO;};
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

- (SKSignal*)combineLatestWithSignal:(SKSignal*)signal
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
        
        [signal subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

+ (SKSignal*)combineLatestSignals:(NSArray<SKSignal*>*)signals
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        __block SKSignal* theFirst = nil;
        for (SKSignal* signal in signals) {
            if (theFirst == nil) {
                theFirst = signal;
                continue;
            }
            
            theFirst = [theFirst combineLatestWithSignal:signal];
        }
        [theFirst subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

- (SKSignal *)throttle:(NSTimeInterval)interval {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        __block BOOL hasNextInvoke = YES;
        [self subscribeNext:^(id x) {
            if (hasNextInvoke == NO) return ;
            hasNextInvoke = NO;
            [subscriber sendNext:x];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hasNextInvoke = YES;
            });
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
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
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribeNext:^(id x) {
            [scheduler schedule:^{
                [subscriber sendNext:x];
            }];
        } error:^(NSError *error) {
            [scheduler schedule:^{
                [subscriber sendError:error];
            }];
        } complete:^(id value) {
            [scheduler schedule:^{
                [subscriber sendComplete:value];
            }];
        }];
    }];
}

@end
