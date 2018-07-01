//
//  UIButton+SKSignalSupport.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/28.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "UIButton+SKSignalSupport.h"
#import "UIControl+SKSignalSupport.h"
#import "SKSignal.h"

@implementation UIButton (SKSignalSupport)

- (SKSignal *)sk_clickSignal {
    return [self sk_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
