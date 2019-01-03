//
//  SKCompoundDisposable.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/9.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKCompoundDisposable.h"
#import "SKObjectifyMarco.h"

@implementation SKCompoundDisposable {
    CFMutableArrayRef _disposes;
}

static void disposeEach(const void *item ,void *context) {
    SKDisposable *disposable = (__bridge id)item;
    [disposable dispose];
}

- (instancetype)initWithBlock:(dispatch_block_t)block {
    NSArray *disposables = block ? @[[SKDisposable disposableWithBlock:block]] : nil;
    return [self initWithDisposes:disposables];
}

+ (instancetype)disposableWithBlock:(dispatch_block_t)block {
    NSArray *disposables = block ? @[[SKDisposable disposableWithBlock:block]] : nil;
    return [self disposableWithdisposes:disposables];
}

- (instancetype)initWithDisposes:(NSArray<SKDisposable *> *)disposes {
    self = [super initWithBlock:nil];
    if (self) {
        if (disposes.count > 0) {
            _disposes = CFArrayCreateMutableCopy(CFAllocatorGetDefault(), 0, (__bridge CFArrayRef)disposes);
        }
    }
    return self;
}

+ (instancetype)compoundDisposable {
    return [self disposableWithBlock:nil];
}

+ (instancetype)disposableWithdisposes:(NSArray<SKDisposable *> *)disposes {
    return [[self alloc] initWithDisposes:disposes];
}

- (BOOL)isDisposed {
    BOOL disposaed = NO;
    OSSpinLockLock(&_lock);
    disposaed = __disposable;
    OSSpinLockUnlock(&_lock);
    return disposaed;
}

- (void)addDisposable:(SKDisposable *)disposable {
    if (disposable == nil) return;
    BOOL shouldDispose = self.isDisposed;
    OSSpinLockLock(&_lock);
    if (!shouldDispose) {
        if (_disposes == NULL) {
            _disposes = CFArrayCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeArrayCallBacks);
        }
        CFArrayAppendValue(_disposes, (__bridge const void *)(disposable));
    }
    OSSpinLockUnlock(&_lock);
    if (shouldDispose) [disposable dispose];
}

- (void)removeDisposable:(SKDisposable *)disposable {
    if (disposable == nil) return;
    OSSpinLockLock(&_lock);
    if (_disposes != NULL) {
        NSInteger item_count = CFArrayGetCount(_disposes);
        for (NSInteger i = item_count - 1; i >= 0; i --) {
            if (disposable == (__bridge SKDisposable *)CFArrayGetValueAtIndex(_disposes, i)) {
                CFArrayRemoveValueAtIndex(_disposes, i);
                break;
            }
        }
    }
    OSSpinLockUnlock(&_lock);
}

- (void)dispose {
    if (self.isDisposed == 0 && _disposes) {
        OSSpinLockLock(&_lock);
        __disposable = YES;
        OSSpinLockUnlock(&_lock);
        NSInteger count = CFArrayGetCount(_disposes);
        CFArrayApplyFunction(_disposes, CFRangeMake(0, count), disposeEach, nil);
        CFRelease(_disposes);
        _disposes = NULL;
    }
}

- (void)dealloc {
    if (_disposes) {
        CFRelease(_disposes);
        _disposes = NULL;
    }
}

@end
