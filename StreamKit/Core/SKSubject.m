//
//  SKSubject.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/6/30.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSubject.h"
#import "SKObjectifyMarco.h"
#import "SKCompoundDisposable.h"
#import "SKPassthroughSubscriber.h"
#import "SKScheduler.h"

@interface SKSubject ()

@property (nonatomic,strong) NSMutableArray<id<SKSubscriber>> *subscribers;

@property (nonatomic,strong) SKCompoundDisposable *compoundDisposable;

@end

@implementation SKSubject

+ (instancetype)subject {
    SKSubject *subject = [self new];
    return subject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _subscribers = [NSMutableArray array];
        _compoundDisposable = [SKCompoundDisposable disposableWithBlock:nil];
    }
    return self;
}

- (SKDisposable *)subscribe:(id<SKSubscriber>)subscriber {
    NSParameterAssert(subscriber);
    SKCompoundDisposable *subscribeDisposable = [SKCompoundDisposable disposableWithdisposes:nil];
    SKPassthroughSubscriber *passthroughSubscriber = [[SKPassthroughSubscriber alloc] initWithSubscriber:subscriber disposable:subscribeDisposable];
    @synchronized (self) {
        [self.subscribers addObject:passthroughSubscriber];
    }
    [subscribeDisposable addDisposable:[SKDisposable disposableWithBlock:^{
        @synchronized (self) {
            [self.subscribers removeObject:passthroughSubscriber];
        }
    }]];
    return subscribeDisposable;
}

- (void)enumerSubscriber:(void(^)(id<SKSubscriber> subscriber))block {
    NSCParameterAssert(block);
    NSArray<id<SKSubscriber>> *subscribers = nil;
    @synchronized (self) {
        subscribers = [self.subscribers copy];
    }
    [subscribers enumerateObjectsUsingBlock:^(id<SKSubscriber>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

- (void)sendNext:(id)value {
    
    [self enumerSubscriber:^(id<SKSubscriber> subscriber) {
        [subscriber sendNext:value];
    }];
}

- (void)sendError:(NSError*)error {
    [self.compoundDisposable dispose];
    [self enumerSubscriber:^(id<SKSubscriber> subscriber) {
        [subscriber sendError:error];
    }];
}

- (void)sendCompleted {
    [self.compoundDisposable dispose];
    [self enumerSubscriber:^(id<SKSubscriber> subscriber) {
        [subscriber sendCompleted];
    }];
}

- (void)didSubscriberWithDisposable:(SKCompoundDisposable *)other {
    if (other == nil || other.isDisposed) return;
    [self.compoundDisposable addDisposable:other];
    @weakify(self,other)
    [other addDisposable:[SKDisposable disposableWithBlock:^{
        @strongify(self,other)
        [self.compoundDisposable removeDisposable:other];
    }]];
}

@end
