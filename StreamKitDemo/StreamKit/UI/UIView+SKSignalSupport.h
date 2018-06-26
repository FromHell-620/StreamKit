//
//  UIView+SKSignalSupport.h
//  StreamKitDemo
//
//  Created by imac on 2018/6/26.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKSignal;

@interface UIView (SKSignalSupport)

- (SKSignal *)sk_clickSignal;

@end
