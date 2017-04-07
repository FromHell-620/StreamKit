//
//  UIView+ReactiveX.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/7.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKSignal;
@interface UIView (ReactiveX)

- (SKSignal*)sk_eventSignal;

@end
