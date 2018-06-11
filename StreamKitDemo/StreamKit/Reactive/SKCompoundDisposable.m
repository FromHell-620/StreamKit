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

static void disposeEach(const void *item ,void *context) {
    SKDisposable *disposable = (__bridge id)item;
    [disposable dispose];
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
    if (disposable.isDisposed || disposable == nil) return;
    BOOL shouldDispose = NO;
    OSSpinLockLock(&_lock);
    if (self.isDisposed) shouldDispose = YES;
    else {
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
        for (NSInteger i = item_count - 1; item_count >= 0; i --) {
            if (disposable == (__bridge SKDisposable *)CFArrayGetValueAtIndex(_disposes, i)) {
                CFArrayRemoveValueAtIndex(_disposes, i);
                break;
            }
        }
    }
    OSSpinLockUnlock(&_lock);
}

- (void)dispose {
    if (_disposes) {
        CFArrayApplyFunction(_disposes, CFRangeMake(0, CFArrayGetCount(_disposes)), disposeEach, nil);
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
