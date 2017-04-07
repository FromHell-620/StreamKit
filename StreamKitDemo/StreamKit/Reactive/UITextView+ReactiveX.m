//
//  UITextView+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/7.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "UITextView+ReactiveX.h"
#import "UITextView+StreamKit.h"
#import "SKObjectifyMarco.h"
#import "SKSubscriber.h"
#import "SKSignal.h"

@implementation UITextView (ReactiveX)

- (SKSignal*)sk_textSignal
{
    @weakify(self)
    return [[SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
        @strongify(self)
        self.sk_textViewDidChange(^(UITextView* textView){
            [subscriber sendNext:textView];
        });
    }] map:^id(UITextView* x) {
        return x.text;
    }];
}

@end
