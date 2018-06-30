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

- (void)sk_setDelegateProxy:(SKDelegateProxy *)sk_delegateProxy {
    objc_setAssociatedObject(self, @selector(sk_delegateProxy), sk_delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SKDelegateProxy *)sk_delegateProxy {
    return objc_getAssociatedObject(self, _cmd);
}

@end
