//
//  NSObject+SKDelegateProxy.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/30.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "NSObject+SKDelegateProxy.h"
#import "SKDelegateProxy.h"
#import <objc/runtime.h>

@implementation NSObject (SKDelegateProxy)

static CFMutableDictionaryRef protocolsMap() {
    static CFMutableDictionaryRef map = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    });
    return map;
}

- (void)sk_setDelegate:(SKDelegateProxy *)sk_delegateProxy {
    objc_setAssociatedObject(self, @selector(sk_delegateProxy), sk_delegateProxy, OBJC_ASSOCIATION_RETAIN);
}

- (SKDelegateProxy *)sk_delegateProxy {
    @synchronized (self) {
        SKDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
        if (proxy == nil) {
            const char * className = class_getName(object_getClass(self));
            const void *value = CFDictionaryGetValue(protocolsMap(), className);
            if (value == kCFNull) {
                return nil;
            }
            if (value) {
                proxy = (__bridge SKDelegateProxy *)value;
            }else {
                unsigned int protocol_count;
                __unsafe_unretained Protocol **protocols = class_copyProtocolList(object_getClass(self), &protocol_count);
                for (unsigned int i = 0; i < protocol_count; i ++) {
                    Protocol *protocol = protocols[i];
                    if (strstr(protocol_getName(protocol), "delegate")) {
                        proxy = [[SKDelegateProxy alloc] initWithProtocol:protocol];
                        CFDictionarySetValue(protocolsMap(), className, (__bridge const void *)(proxy));
                        break;
                    }
                    if (i == protocol_count - 1) {
                        CFDictionarySetValue(protocolsMap(), className, kCFNull);
                    }
                }
            }
            objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return proxy;
    }
}

@end
