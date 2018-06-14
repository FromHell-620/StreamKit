//
//  SKSignal+Operations.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/14.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKSignal+Operations.h"
#import "SKSubscriber.h"

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

- (SKSignal*)concat:(SKSignal *)signal {
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        [self subscribeNext:^(id x) {
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } complete:^(id value) {
            [signal subscribe:subscriber];
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
