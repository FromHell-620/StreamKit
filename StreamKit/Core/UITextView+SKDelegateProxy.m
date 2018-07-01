//
//  UITextView+SKDelegateProxy.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/7/1.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "UITextView+SKDelegateProxy.h"
#import "NSObject+SKDelegateProxy.h"
#import "SKDelegateProxy.h"
#import <objc/runtime.h>

@implementation UITextView (SKDelegateProxy)

- (SKDelegateProxy *)sk_delegateProxy {
    @synchronized (self) {
        SKDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
        if (!proxy) {
            proxy = [[SKDelegateProxy alloc] initWithProtocol:@protocol(UITextViewDelegate)];
            proxy.realDelegate = self.delegate;
            self.delegate = (id<UITextViewDelegate>)proxy;
            [self sk_setDelegateProxy:proxy];
        }
        return proxy;
    }
}

@end
