//
//  SKPassthroughSubscriber.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/19.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKPassthroughSubscriber.h"
#import "SKCompoundDisposable.h"

@interface SKPassthroughSubscriber ()

@property (nonatomic,strong) id<SKSubscriber> innerSubscriber;

@property (nonatomic,strong) SKCompoundDisposable *disposable;

@end

@implementation SKPassthroughSubscriber

- (instancetype)initWithSubscriber:(id<SKSubscriber>)subscriber disposable:(SKCompoundDisposable *)disposable {
    self = [super init];
    if (self) {
        _innerSubscriber = subscriber;
        _disposable = disposable;
        [_innerSubscriber didSubscriberWithDisposable:disposable];
    }
    return self;
}

- (void)sendNext:(id)value {
    if (self.disposable.isDisposed) return;
    [self.innerSubscriber sendNext:value];
}

- (void)sendError:(NSError *)error {
    if (self.disposable.isDisposed) return;
    [self.innerSubscriber sendError:error];
}

- (void)sendCompleted {
    if (self.disposable.isDisposed) return;
    [self.innerSubscriber sendCompleted];
}

- (void)didSubscriberWithDisposable:(SKCompoundDisposable *)other {
    if (self.disposable != other) {
        [self.disposable addDisposable:other];
    }
}

@end
