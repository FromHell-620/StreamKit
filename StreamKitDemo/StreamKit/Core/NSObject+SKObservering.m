//
//  NSObject+SKObserveing.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/24.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "NSObject+SKObservering.h"
#import "SKSignal.h"
#import "SKSignal+Operations.h"
#import "NSObject+SKDeallocating.h"
#import "SKSubscriber.h"
#import "SKDisposable.h"
#import "SKCompoundDisposable.h"
#import "SKObjectifyMarco.h"

@interface _SKObserverTarget : NSObject

- (instancetype)initWithSubscriber:(id<SKSubscriber>)subscriber;


@end

@implementation _SKObserverTarget {
    id<SKSubscriber> _subscriber;
#ifdef DEBUG
    __unsafe_unretained id _observer;
    NSString *_keyPath;
#endif
}

- (instancetype)initWithSubscriber:(id<SKSubscriber>)subscriber {
    self = [super init];
    if (self) {
        _subscriber = subscriber;
    }
    return self;
}

#ifdef DEBUG
- (instancetype)initWithSubscriber:(id<SKSubscriber>)subscriber observer:(id)observer keyPath:(NSString *)keyPath {
    self = [super init];
    if (self) {
        _subscriber = subscriber;
        _observer = observer;
        _keyPath = keyPath;
    }
    return self;
}

#endif

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (_subscriber) {
        [_subscriber sendNext:change];
    }
}

#ifdef DEBUG
- (void)dealloc {
    NSLog(@"observerTarget will dealloc by observer is %@ keyPath is %@",_observer,_keyPath);
}

#endif
@end

@implementation NSObject (SKObservering)

- (SKSignal *)sk_observerWithKeyPath:(NSString *)keyPath {
    return [self sk_observerWithKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld];
}

- (SKSignal *)sk_observerWithKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options {
    @weakify(self)
    NSObject *target = self;
    @unsafeify(target)
    return [SKSignal signalWithBlock:^SKDisposable *(id<SKSubscriber> subscriber) {
        @strongify(self)
        _SKObserverTarget *observer = nil;
#ifdef DEBUG
        observer = [[_SKObserverTarget alloc] initWithSubscriber:subscriber observer:self keyPath:keyPath];
#else
        observer  = [[_SKObserverTarget alloc] initWithSubscriber:subscriber];
#endif
        [self addObserver:observer forKeyPath:keyPath options:options context:nil];
        SKDisposable *removeDisposable = [SKDisposable disposableWithBlock:^{
            @strongify(target)
            [target removeObserver:observer forKeyPath:keyPath];
        }];
        [self.deallocDisposable addDisposable:removeDisposable];
        return [SKDisposable disposableWithBlock:^{
            [removeDisposable dispose];
        }];
    }];
}

- (SKSignal *)sk_autoObserverWithKeyPath:(NSString *)keyPath {
    return [self sk_autoObserverWithKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld];
}

- (SKSignal *)sk_autoObserverWithKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options {
    @weakify(self)
    return [[SKSignal defer:^SKSignal *{
        @strongify(self)
        id x = [self valueForKeyPath:keyPath];
        return [SKSignal return:x?@{@"new":x,@"old":x}:nil];
    }] concat:[self sk_observerWithKeyPath:keyPath options:options]];
}

@end
