//
//  SKCompoundDisposable.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/9.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKCompoundDisposable.h"
#import "SKObjectifyMarco.h"
#import <libkern/OSAtomic.h>

@implementation SKCompoundDisposable {
    CFMutableArrayRef _disposes;
    OSSpinLock _lock;
}

- (instancetype)initWithBlock:(dispatch_block_t)block {
    return [self initWithDisposes:@[[SKDisposable disposableWithBlock:block]]];
}

+ (instancetype)disposableWithBlock:(dispatch_block_t)block {
    return [self disposableWithdisposes:@[[SKDisposable disposableWithBlock:block]]];
}

- (instancetype)initWithDisposes:(NSArray<SKDisposable *> *)disposes {
    @weakify(self)
    void (^disposeBlock)(void) = ^{
        @strongify(self)
        [self dispose];
    };
    self = [super initWithBlock:disposeBlock];
    if (self) {
        if (disposes.count > 0) {
            _disposes = CFArrayCreateMutableCopy(CFAllocatorGetDefault(), 0, (__bridge CFArrayRef)disposes);
        }
    }
    return self;
}

+ (instancetype)disposableWithdisposes:(NSArray<SKDisposable *> *)disposes {
    return [[self alloc] initWithDisposes:disposes];
}

- (void)addDisposable:(SKDisposable *)disposable {
    NSParameterAssert(disposable);
    if (disposable.isDisposed) return;
    OSSpinLockLock(&_lock);
    if (self.isDisposed) [disposable dispose];
    else {
        if (_disposes == NULL) {
            _disposes = CFArrayCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeArrayCallBacks);
        }
        CFArrayAppendValue(_disposes, (__bridge const void *)(disposable));
    }
    OSSpinLockUnlock(&_lock);
    
}

- (void)dispose {
    
}

@end
