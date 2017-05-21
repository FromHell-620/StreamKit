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

+ (instancetype)signalWithBlock:(void(^)(id<SKSubscriber> subscriber))block {
    SKSignal *signal = [SKSignal new];
    signal->_block = [block copy];
    return signal;
}

- (void)subscribe:(id<SKSubscriber>)subscriber {
    !_block?:_block(subscriber);
}

- (void)subscribeNext:(void(^)(id x))next {
    [self subscribeNext:next error:nil complete:nil];
}

- (void)subscribeError:(void(^)(NSError *error))error {
    [self subscribeNext:nil error:error complete:nil];
}

- (void)subscribeNext:(void (^)(id x))next
                error:(void(^)(NSError *error))error {
    [self subscribeNext:next error:error complete:nil];
}

- (void)subscribe:(void (^)(id value))next
         complete:(void(^)(id value))complete {
    [self subscribeNext:next error:nil complete:complete];
}

- (void)subscribeNext:(void (^)(id))next
                error:(void(^)(NSError *error))error
             complete:(void(^)(id value))complete {
    SKSubscriber *subscriber = [SKSubscriber subscriberWithNext:next error:error complete:complete];
    !_block?:_block(subscriber);
}

- (void)subscribeWithReturnValue:(id(^)(id x))next {
    SKSubscriber *subscriber = [SKSubscriber subscriberWithReturnValueNext:next complete:nil];
    !_block?:_block(subscriber);
}


- (void)subscribeWithReturnValue:(id(^)(id x))next complete:(id(^)(id x))complete {
    SKSubscriber *subscriber = [SKSubscriber subscriberWithReturnValueNext:next complete:complete];
    !_block?:_block(subscriber);
}

@end

@implementation SKSignal (operation)

- (SKSignal *)doNext:(void (^)(id))next {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
       [self subscribeNext:^(id x) {
           next(x);
           [subscriber sendNext:x];
       } error:^(NSError *error) {
           [subscriber sendError:error];
       } complete:^(id value) {
           [subscriber sendComplete:value];
       }];
    }];
}

- (SKSignal*)concat:(void(^)(id<SKSubscriber> subscriber))block {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
            [self subscribeNext:^(id x) {
                [subscriber sendNext:x];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            } complete:^(id value) {
                [subscriber sendComplete:value];
            }];
        }];
}

- (SKSignal*)flattenMap:(SKSignal *(^)(id value))block {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribeNext:^(id x) {
            SKSignal* signal = block(x);
            [signal subscribeNext:^(id x) {
                [subscriber sendNext:x];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            } complete:^(id value) {
                [subscriber sendComplete:value];
            }];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [subscriber sendComplete:value];
        }];
    }];
}

- (SKSignal *)map:(id(^)(id x))block {
    return [self flattenMap:^SKSignal *(id value) {
        return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
            [subscriber sendNext:block(value)];
        }];
    }];
}

- (SKSignal *)filter:(BOOL(^)(id x))block {
    return [self flattenMap:^SKSignal *(id value) {
        return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
            if (block(value)) {
                [subscriber sendNext:value];
            }
        }];
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
                    [subscriber sendNext:x];
                }
                pre_value = x;
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

@end
