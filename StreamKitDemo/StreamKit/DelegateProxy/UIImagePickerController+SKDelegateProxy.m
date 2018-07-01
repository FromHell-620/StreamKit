//
//  UIImagePickerController+SKDelegateProxy.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/7/1.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "UIImagePickerController+SKDelegateProxy.h"
#import "NSObject+SKDelegateProxy.h"
#import "SKDelegateProxy.h"
#import <objc/runtime.h>

@implementation UIImagePickerController (SKDelegateProxy)

- (SKDelegateProxy *)sk_delegateProxy {
    @synchronized (self) {
        SKDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
        if (!proxy) {
            proxy = [[SKDelegateProxy alloc] initWithProtocol:@protocol(UIImagePickerControllerDelegate)];
            proxy.realDelegate = self.delegate;
            self.delegate = (id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)proxy;
            [self sk_setDelegateProxy:proxy];
        }
        return proxy;
    }
}

@end
