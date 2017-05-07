//
//  SKSignal.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/31.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSignal.h"
#import "SKSubscriber.h"

@implementation SKSignal {
    void(^_block)(id<SKSubscriber> subscriber);
}

+ (instancetype)signalWithBlock:(void(^)(id<SKSubscriber> subscriber))block
{
    SKSignal* signal = [SKSignal new];
    signal->_block = [block copy];
    return signal;
}

- (void)subscribe:(void(^)(id x))next
{
    SKSubscriber* subscriber = [SKSubscriber subscriberWithNext:next complete:nil];
    !_block?:_block(subscriber);
}

- (void)subscribeWithReturnValue:(id(^)(id x))next
{
    SKSubscriber* subscriber = [SKSubscriber subscriberWithReturnValueNext:next complete:nil];
    !_block?:_block(subscriber);
}

- (void)subscribe:(void (^)(id value))next complete:(void(^)(id value))complete
{
    SKSubscriber* subscriber = [SKSubscriber subscriberWithNext:next complete:complete];
    !_block?:_block(subscriber);
}

- (void)subscribeWithReturnValue:(id(^)(id x))next complete:(id(^)(id x))complete
{
    SKSubscriber* subscriber = [SKSubscriber subscriberWithReturnValueNext:next complete:complete];
    !_block?:_block(subscriber);
}

@end

@implementation SKSignal (operation)

- (SKSignal*)concat:(void(^)(id<SKSubscriber> subscriber))block
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
            [self subscribe:^(id x) {
                [subscriber sendNext:x];
            }];
        }];
}

- (SKSignal*)flattenMap:(SKSignal*(^)(id value))block {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
       [self subscribe:^(id x) {
           SKSignal* signal = block(x);
           if (signal) {
               [signal subscribe:^(id value) {
                   [subscriber sendNext:value];
               } complete:^(id value) {
                   [subscriber sendComplete:value];
               }];
           }
       }];
    }];
}

- (SKSignal*)map:(id(^)(id x))block
{
    return [self flattenMap:^SKSignal *(id value) {
        return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
            [subscriber sendNext:block(value)];
        }];
    }];
}

- (SKSignal*)filter:(BOOL(^)(id x))block
{
    return [self flattenMap:^SKSignal *(id value) {
        return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
            if (block(value)) {
                [subscriber sendNext:value];
            }
        }];
    }];
}

- (SKSignal*)ignore:(id)value
{
    return [self filter:^BOOL(id x) {
        return [x isEqual:value];
    }];
}

- (SKSignal*)takeUntil:(SKSignal*)signal
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
            [signal subscribe:^(id value) {
                [subscriber sendComplete:value];
            } complete:^(id value) {
                [subscriber sendComplete:value];
            }];
        
        [self subscribe:^(id x) {
            [subscriber sendNext:x];
        }];
    }];
}

- (SKSignal*)distinctUntilChanged
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        __block id pre_value = nil;
            [self subscribe:^(id x) {
                if (!(pre_value == x || [pre_value isEqual:x])) {
                    [subscriber sendNext:x];
                }
                pre_value = x;
            }];
    }];
}

- (SKSignal*)take:(NSUInteger)takes
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        __block NSUInteger already_takes = 0;
        [self subscribe:^(id x) {
            if (already_takes < takes) {
                [subscriber sendNext:x];
            }
            already_takes ++;
        }];
    }];
}

- (SKSignal*)takeUntilBlock:(BOOL(^)(id x))block
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribe:^(id x) {
            if (block(x) == NO ) {
                [subscriber sendNext:x];
            }
        }];
    }];
}

- (SKSignal*)takeWhileBlock:(BOOL(^)(id x))block
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribe:^(id x) {
            if (block(x) == YES) {
                [subscriber sendNext:x];
            }
        }];
    }];
}

- (SKSignal*)skip:(NSUInteger)takes
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        __block NSUInteger already = 0;
        [self subscribe:^(id x) {
            already ++;
            if (already > takes) {
                [subscriber sendNext:x];
            }
        }];
    }];
}

- (SKSignal*)skipUntilBlock:(BOOL(^)(id x))block
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
       [self subscribe:^(id x) {
           if (block(x) == YES) {
               [subscriber sendNext:x];
           }
       }];
    }];
}

- (SKSignal*)skipWhileBlock:(BOOL(^)(id x))block
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribe:^(id x) {
            if (block(x) == NO) {
                [subscriber sendNext:x];
            }
        }];
    }];
}

- (SKSignal*)startWith:(id)value
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [subscriber sendNext:value];
        [self subscribe:^(id x) {
            [subscriber sendNext:x];
        }];
    }];
}

- (SKSignal*)combineLatestWithSignal:(SKSignal*)signal
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribe:^(id value) {
            [subscriber sendNext:value];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
        
        [signal subscribe:^(id value) {
            [subscriber sendNext:value];
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
       [theFirst subscribe:^(id x) {
           [subscriber sendNext:x];
       }];
    }];
}

- (SKSignal*)throttle:(NSTimeInterval)interval
{
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        __block BOOL hasNextInvoke = YES;
        [self subscribe:^(id x) {
            if (hasNextInvoke == NO) return ;
            hasNextInvoke = NO;
            [subscriber sendNext:x];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hasNextInvoke = YES;
            });
        }];
    }];
}

@end
