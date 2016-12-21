//
//  UIControl+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/15.
//  Copyright © 2016年 苏南. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (StreamKit)

- (UIControl* (^)(BOOL enabled))sk_enabled;

- (UIControl* (^)(BOOL selected))sk_selected;

- (UIControl* (^)(BOOL highlighted))sk_highlighted;

- (UIControl* (^)(UIControlContentVerticalAlignment contentVerticalAlignment))lm_contentVerticalAlignment;

- (UIControl* (^)(UIControlContentHorizontalAlignment contentHorizontalAlignment))lm_contentHorizontalAlignment;

- (UIControl* (^)(UIControlEvents controlEvents,void(^block)(__kindof UIControl* target)))sk_addEventBlock;

- (UIControl* (^)(UIControlEvents controlEvents))sk_removeEventBlock;

- (UIControl* (^)())sk_removeAllEventBlock;

@end
