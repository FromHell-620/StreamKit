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

- (UIControl* (^)(id target,UIControlEvents controlEvents,void(^block)(id target)))sk_addTargetBlock;

- (UIControl* (^)(id target,UIControlEvents controlEvents))sk_removeTargetBlock;

- (UIControl* (^)(id target))sk_removeAllTargetBlock;

- (UIControl* (^)())sk_clearTargetBlock;


@end
