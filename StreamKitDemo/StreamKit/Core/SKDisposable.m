//
//  SKDisposable.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/9.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKDisposable.h"
#import "SKScopedDisposable.h"

@interface SKDisposable ()

@property (nonatomic,copy) dispatch_block_t disposeBlock;

@end

@implementation SKDisposable

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
    BOOL dispose = __disposable || _disposeBlock == nil;
    OSSpinLockUnlock(&_lock);
    return dispose;
}

- (void)dispose {
    if (self.isDisposed) return;
    dispatch_block_t selfDisposeBlock = self.disposeBlock;
    OSSpinLockLock(&_lock);
    __disposable = YES;
    self.disposeBlock = nil;
    OSSpinLockUnlock(&_lock);
    selfDisposeBlock();
}

- (SKDisposable *)asScopedDisposable {
    return [SKScopedDisposable disposableWithBlock:^{
        [self dispose];
    }];
}

@end
