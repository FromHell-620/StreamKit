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
#import "SKDelegateProxy.h"
#import "SKObjectifyMarco.h"
#import "NSObject+SKSelectorSignal.h"
#import "NSObject+SKDeallocating.h"
#import "NSObject+SKDelegateProxy.h"
#import "UITextView+SKDelegateProxy.h"

@implementation UITextView (SKSignalSupport)

- (SKSignal *)sk_textSignal {
    @weakify(self)
    return [[[[SKSignal defer:^{
        @strongify(self)
        return [SKSignal return:@[self]];
    }] concat:[self.sk_delegateProxy sk_signalForSelector:@selector(textViewDidChange:) protocol:@protocol(UITextViewDelegate)]] reduceEach:^ id(UITextView *x) {
        return x.text;
    }] takeUntil:self.deallocSignal];
}

@end
