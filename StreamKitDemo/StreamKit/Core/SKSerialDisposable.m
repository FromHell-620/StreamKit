//
//  SKSerialDisposable.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/17.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKSerialDisposable.h"
#import "SKObjectifyMarco.h"
#import <libkern/OSAtomic.h>

@implementation SKSerialDisposable {
    OSSpinLock _lock;
    SKDisposable *_disposable;
}

- (instancetype)initWithBlock:(dispatch_block_t)block {
    SKDisposable *disposable = [SKDisposable disposableWithBlock:block];
    return [self initWithDisposable:disposable];
}

- (instancetype)initWithDisposable:(SKDisposable *)disposable {
    self = [super initWithBlock:nil];
    if (self) {
        self.disposable = disposable;
    }
    return self;
}

+ (instancetype)disposableWithDisposable:(SKDisposable *)disposable {
    return [[self alloc] initWithDisposable:disposable];
}

- (void)setDisposable:(SKDisposable *)disposable {
    [self swapInDisposable:disposable];
}

- (BOOL)isDisposed {
    BOOL alreadDiposed;
    OSSpinLockLock(&_lock);
    alreadDiposed = __disposable;
    OSSpinLockUnlock(&_lock);
    return alreadDiposed;
}

- (SKDisposable *)disposable {
    SKDisposable *disposable = nil;
    OSSpinLockLock(&_lock);
    disposable = _disposable;
    OSSpinLockUnlock(&_lock);
    return disposable;
}

- (SKDisposable *)swapInDisposable:(SKDisposable *)disposable {
    if (disposable == nil) return nil;
    BOOL alreadDisposed = self.isDisposed;
    SKDisposable *existingDisposable = nil;
    OSSpinLockLock(&_lock);
    {
        if (!alreadDisposed) {
            existingDisposable = _disposable;
            _disposable = disposable;
        }
    }
    OSSpinLockUnlock(&_lock);
    if (alreadDisposed) {
        [disposable dispose];
        return nil;
    }
    return existingDisposable;
}

- (void)dispose {
    if (self.isDisposed) return;
    SKDisposable *selfDisposable;
    OSSpinLockLock(&_lock);
    {
        selfDisposable = _disposable;
        _disposable = nil;
        __disposable = YES;
    }
    OSSpinLockUnlock(&_lock);
    [selfDisposable dispose];
}

@end
