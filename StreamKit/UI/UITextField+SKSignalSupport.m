//
//  UITextField+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/7.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "UITextField+SKSignalSupport.h"
#import "UIControl+SKSignalSupport.h"
#import "SKSignal+Operations.h"
#import "SKObjectifyMarco.h"
#import "SKSubscriber.h"
#import "NSObject+SKDeallocating.h"

@implementation UITextField (SKSignalSupport)

- (SKSignal*)sk_textSignal {
    @weakify(self)
    return [[[[SKSignal defer:^{
        @strongify(self)
        return [SKSignal return:self];
    }] concat:[self sk_signalForControlEvents:UIControlEventAllEditingEvents]] map:^(UITextField *x) {
        return x.text;
    }] takeUntil:self.deallocSignal];
}

@end
