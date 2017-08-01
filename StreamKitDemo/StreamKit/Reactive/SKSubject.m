//
//  SKSubject.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/6/30.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSubject.h"
#import "NSArray+ReactiveX.h"
#import "SKObjectifyMarco.h"

@interface SKSubject ()

@property (nonatomic,strong) NSMutableArray<id<SKSubscriber>> *subscribers;

@property (nonatomic,strong) NSMutableArray<id<SKSubscriber>> *privateSubscribers;

@end

@implementation SKSubject

@synthesize completeSignal = _completeSignal;

+ (instancetype)subject {
    SKSubject *subject = [SKSubject new];
    subject.subscribers = [NSMutableArray array];
    return subject;
}

- (NSMutableArray<id<SKSubscriber>> *)privateSubscribers {
    if (!_privateSubscribers) {
        _privateSubscribers = [NSMutableArray array];
    }
    return _privateSubscribers;
}

- (NSArray<id<SKSubscriber>> *)completeSubscribers {
    return [self.privateSubscribers copy];
}

- (SKSignal *)completeSignal {
    if (!_completeSignal) {
        @weakify(self)
        _completeSignal = [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
            @strongify(self)
            [self.privateSubscribers addObject:subscriber];
        }];
    }
    return _completeSignal;
}

- (void)subscribe:(id<SKSubscriber>)subscriber {
    NSParameterAssert(subscriber);
    @synchronized (self) {
        [self.subscribers addObject:subscriber];
    }
}

- (void)enumerSubscriber:(void(^)(id<SKSubscriber> subscriber))block {
    [self.subscribers enumerateObjectsUsingBlock:^(id<SKSubscriber>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

- (void)sendNext:(id)value {
    [self enumerSubscriber:^(id<SKSubscriber> subscriber) {
        [subscriber sendNext:value];
    }];
}

- (void)sendError:(NSError*)error {
    [self enumerSubscriber:^(id<SKSubscriber> subscriber) {
        [subscriber sendError:error];
    }];
}

- (id)sendNextWithReturnValue:(id)value {
    return nil;
}

- (void)sendComplete:(id)value {
    [self enumerSubscriber:^(id<SKSubscriber> subscriber) {
        [subscriber sendComplete:value];
    }];
}

- (id)sendCompleteWithReturnValue:(id)value {
    return nil;
}

@end
