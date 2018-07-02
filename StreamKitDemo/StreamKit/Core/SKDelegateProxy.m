//
//  SKDelegatePoxy.m
//  StreamKitDemo
//
//  Created by imac on 2018/6/29.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKDelegateProxy.h"
#import "NSObject+SKSelectorSignal.h"
#import <objc/runtime.h>

@implementation SKDelegateProxy {
    Protocol *_protocol;
}

- (instancetype)initWithProtocol:(Protocol *)protocol {
    self = [super init];
    if (self) {
        _protocol = protocol;
    }
    return self;
}

- (SKSignal *)sk_signalForSelector:(SEL)selector {
    return nil;
}

- (BOOL)isProxy {
    return YES;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.realDelegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.realDelegate];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    struct objc_method_description method = protocol_getMethodDescription(_protocol, aSelector, YES, YES);
    if (method.name == NULL) {
        method = protocol_getMethodDescription(_protocol, aSelector, NO, YES);
        if (method.name == NULL) return [super methodSignatureForSelector:aSelector];
    }
    return [NSMethodSignature signatureWithObjCTypes:method.types];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    __autoreleasing id realDelegate = self.realDelegate;
    if ([realDelegate respondsToSelector:aSelector]) return YES;
    return [super respondsToSelector:aSelector];
}

@end
