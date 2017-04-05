//
//  UIControl+ReactiveX.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/5.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKSignal;
@interface UIControl (ReactiveX)

- (SKSignal*)sk_signalForControlEvents:(UIControlEvents)controlEvents;

@end
