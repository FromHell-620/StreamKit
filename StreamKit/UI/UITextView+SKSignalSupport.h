//
//  UITextView+SKSignalSupport.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/28.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKSignal;

@interface UITextView (SKSignalSupport)

- (SKSignal *)sk_textSignal;

@end
