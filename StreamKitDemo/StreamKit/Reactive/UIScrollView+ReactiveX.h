//
//  UIScrollView+ReactiveX.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/11.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKSignal;
@interface UIScrollView (ReactiveX)

- (SKSignal*)sk_signalForDelegateEndDecelerating;

@end
