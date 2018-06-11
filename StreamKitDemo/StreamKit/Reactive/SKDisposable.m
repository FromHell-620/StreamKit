//
//  SKDisposable.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/9.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKDisposable.h"
#import <libkern/OSAtomic.h>
#import "SKScopedDisposable.h"

@interface SKDisposable ()

@property (nonatomic,copy) dispatch_block_t disposeBlock;

@end

@implementation SKDisposable {
    OSSpinLock _lock;
    struct {
        bool isDisposed : 1;
    } _isDisposed;
}

- (instancetype)initWithBlock:(dispatch_block_t)block {
    self = [super init];
    if (self) {
        _disposeBlock = [block copy];
    }
    return self;
}

+ (instancetype)disposableWithBlock:(dispatch_block_t)block {
    Class class = self;
    return [[class alloc] initWithBlock:block];
}

- (BOOL)isDisposed {
    OSSpinLockLock(&_lock);
    BOOL dispose = _isDisposed.isDisposed || _disposeBlock == nil;
    OSSpinLockUnlock(&_lock);
    return dispose;
}

- (void)dispose {
    if (self.isDisposed) return;
    OSSpinLockLock(&_lock);
    _isDisposed.isDisposed = 1;
    OSSpinLockUnlock(&_lock);
    if (self.disposeBlock) self.disposeBlock();
}

- (SKDisposable *)asScopedDisposable {
    return [SKScopedDisposable disposableWithBlock:^{
        [self dispose];
    }];
}

@end
