//
//  UITextField+ReactiveX.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/7.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "UITextField+ReactiveX.h"
#import "UIControl+ReactiveX.h"
#import "UITextField+StreamKit.h"
#import "SKObjectifyMarco.h"
#import "SKSignal.h"

@implementation UITextField (ReactiveX)

- (SKSignal*)sk_textSignal
{
    return [[self sk_signalForControlEvents:UIControlEventAllEditingEvents] map:^id(UITextField* x) {
        return x.text;
    }];
}

@end
