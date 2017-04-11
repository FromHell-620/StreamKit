//
//  UIScrollView+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/11.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "UIScrollView+ReactiveX.h"
#import "UIScrollView+StreamKit.h"
#import "SKSignal.h"
#import "SKSubscriber.h"
#import "SKObjectifyMarco.h"

@implementation UIScrollView (ReactiveX)

- (SKSignal*)sk_signalForDelegateEndDecelerating
{
    @weakify(self)
    return [SKSignal signalWithBlock:^(id<SKSubscriber> subscriber) {
       @strongify(self)
        self.sk_scrollViewDidEndDecelerating(^(UIScrollView* scrollView){
            [subscriber sendNext:scrollView];
        });
    }];
}

@end
