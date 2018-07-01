//
//  SKSubscriber.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/5.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "SKSubscriber.h"
#import "SKDisposable.h"
#import "SKCompoundDisposable.h"
#import "SKObjectifyMarco.h"

@interface SKSubscriber ()

@property (nonatomic,copy) void (^nextBlock)(id value);

@property (nonatomic,copy) void (^errorBlock)(NSError *error);

@property (nonatomic,copy) void (^completeBlock)(void);

@property (nonatomic,strong) SKCompoundDisposable *subscribersDisposable;

@end

@implementation SKSubscriber {
    id (^_nextWithReturnValue)(id value);
    id (^_completeWithReturnValue)(id value);
}

+ (instancetype)subscriberWithReturnValueNext:(id)next
                                     complete:(id)complete {
    SKSubscriber* subscriber = [SKSubscriber new];
    subscriber->_nextWithReturnValue = [next copy];
    subscriber->_completeWithReturnValue = [complete copy];
    return subscriber;
}

+ (instancetype)subscriberWithNext:(void (^)(id))next
                             error:(void (^)(NSError* error))error
                          completed:(void (^)(void))completed {
    SKSubscriber *subscriber = [[SKSubscriber alloc] init];
    subscriber.nextBlock = next;
    subscriber.errorBlock = error;
    subscriber.completeBlock = completed;
    return subscriber;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        @unsafeify(self)
        SKDisposable *disposable = [SKDisposable disposableWithBlock:^{
            @strongify(self)
            self.nextBlock = nil;
            self.errorBlock = nil;
            self.completeBlock = nil;
        }];
        _subscribersDisposable = [SKCompoundDisposable disposableWithdisposes:@[disposable]];
    }
    return self;
}

- (void)sendNext:(id)value {
    if (self.nextBlock) {
        @synchronized (self) {
            self.nextBlock(value);
        }
    }
}

- (void)sendError:(NSError *)error {
    if (self.errorBlock) {
        @synchronized (self) {
            void (^errorBlock)(NSError *) = [self.errorBlock copy];
            [self.subscribersDisposable dispose];
            errorBlock(error);
        }
    }
}

- (void)sendCompleted {
    if (self.completeBlock) {
        @synchronized (self) {
            dispatch_block_t completeBlock = [self.completeBlock copy];
            [self.subscribersDisposable dispose];
            completeBlock();
        }
    }
}

- (id)sendNextWithReturnValue:(id)value {
    if (_nextWithReturnValue) return _nextWithReturnValue(value);
    return nil;
}

- (id)sendCompleteWithReturnValue:(id)value {
    if (_completeWithReturnValue) return ^id{id returnValue = self->_completeWithReturnValue(value);self->_nextWithReturnValue = nil;self->_completeWithReturnValue = nil;
        return returnValue;}();
    return ^id{self->_nextWithReturnValue = nil;self->_completeWithReturnValue = nil;return nil;}();
}

- (void)didSubscriberWithDisposable:(SKCompoundDisposable *)other {
    NSCParameterAssert(other);
    if (other.isDisposed) return;
    SKCompoundDisposable *selfDisposable = self.subscribersDisposable;
    [selfDisposable addDisposable:other];
    @unsafeify(other)
    [other addDisposable:[SKDisposable disposableWithBlock:^{
        @strongify(other)
        [selfDisposable removeDisposable:other];
    }]];
}

#ifdef DEBUG
- (void)dealloc {
    
}
#endif

@end
