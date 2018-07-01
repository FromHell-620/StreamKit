//
//  UIControl+ReactiveX.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/5.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSignal.h"

@interface UIControl (SKSignalSupport)

- (SKSignal<__kindof UIControl *> *)sk_signalForControlEvents:(UIControlEvents)controlEvents;

@end
