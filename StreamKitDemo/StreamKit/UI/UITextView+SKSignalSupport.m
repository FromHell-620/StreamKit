//
//  UITextView+SKSignalSupport.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/28.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "UITextView+SKSignalSupport.h"
#import "SKSignal.h"
#import "SKSignal+Operations.h"
#import "SKObjectifyMarco.h"
#import "NSObject+SKSelectorSignal.h"
#import "NSObject+SKDeallocating.h"
#import "NSObject+SKDelegateProxy.h"
#import "SKDelegateProxy.h"

@implementation UITextView (SKSignalSupport)

- (SKDelegateProxy *)sk_delegateProxy {
    @synchronized (self) {
        SKDelegateProxy *proxy = [super sk_delegateProxy];
        if (!proxy) {
            proxy = [[SKDelegateProxy alloc] initWithProtocol:@protocol(UITextViewDelegate)];
            proxy.realDelegate = self.delegate;
            self.delegate = (id<UITextViewDelegate>)proxy;
            [self sk_setDelegateProxy:proxy];
        }
        return proxy;
    }
}

- (SKSignal *)sk_textSignal {
    @weakify(self)
    return [[[[SKSignal defer:^{
        @strongify(self)
        return [SKSignal return:@[self]];
    }] concat:[self sk_signalForSelector:@selector(textViewDidChange:)]] reduceEach:^ id(UITextView *x,...) {
        return x.text;
    }] takeUntil:self.deallocSignal];
}

@end
