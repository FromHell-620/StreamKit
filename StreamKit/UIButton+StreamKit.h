//
//  UIButton+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (StreamSuper)

#pragma mark- UIView
- (UIButton* (^)(CGRect frame))sk_frame;

- (UIButton* (^)(CGFloat x))sk_x;

- (UIButton* (^)(CGFloat y))sk_y;

- (UIButton* (^)(CGFloat width))sk_width;

- (UIButton* (^)(CGFloat height))sk_height;

- (UIButton* (^)(CGSize size))sk_size;

- (UIButton* (^)(CGRect bounds))sk_bounds;

- (UIButton* (^)(CGPoint point))sk_center;

- (UIButton* (^)(CGFloat centerX))sk_centerX;

- (UIButton* (^)(CGFloat centerY))sk_centerY;

- (UIButton* (^)(NSInteger tag))sk_tag;

- (UIButton* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UIButton* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UIButton* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UIButton* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UIButton* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UIButton* (^)(CGFloat alpha))sk_alpha;

- (UIButton* (^)(BOOL opaque))sk_opaque;

- (UIButton* (^)(BOOL hidden))sk_hidden;

- (UIButton* (^)(UIViewContentMode mode))sk_contentMode;

- (UIButton* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UIButton* (^)(UIColor* tintColor))sk_tintColor;

#pragma mark- UIControl

- (UIButton* (^)(BOOL enabled))sk_enabled;

- (UIButton* (^)(BOOL selected))sk_selected;

- (UIButton* (^)(BOOL highlighted))sk_highlighted;

- (UIButton* (^)(UIControlContentVerticalAlignment contentVerticalAlignment))lm_contentVerticalAlignment;

- (UIButton* (^)(UIControlContentHorizontalAlignment contentHorizontalAlignment))lm_contentHorizontalAlignment;

- (UIButton* (^)(UIControlEvents controlEvents,void(^block)(__kindof UIButton* target)))sk_addEventBlock;

- (UIButton* (^)(UIControlEvents controlEvents))sk_removeEventBlock;

- (UIButton* (^)())sk_removeAllEventBlock;

@end

@interface UIButton (StreamKit)

+ (UIButton* (^)(CGRect frame))sk_initWithFrame;

+ (UIButton* (^)(UIButtonType buttonType))sk_initWithType;

- (UIButton* (^)(UIFont* font))sk_setFont;

- (UIButton* (^)(NSInteger fontSize))sk_setFontSize;

- (UIButton* (^)(UIEdgeInsets titleEdgeInsets))sk_titleEdgeInsets;

- (UIButton* (^)(UIEdgeInsets imageEdgeInsets))sk_imageEdgeInsets;

- (UIButton* (^)(NSString* title))sk_setTitleNormal;

- (UIButton* (^)(NSString* title))sk_setTitleHighlight;

- (UIButton* (^)(NSString* title))sk_setTitleSelect;

- (UIButton* (^)(NSString* title,UIControlState state))sk_setTitel;

- (UIButton* (^)(UIColor* titleColor))sk_setTitleColorNormal;

- (UIButton* (^)(UIColor* titleColor))sk_setTitleColorHightlight;

- (UIButton* (^)(UIColor* titleColor))sk_setTitleColorSelect;

- (UIButton* (^)(UIColor* titleColor,UIControlState state))sk_setTitleColor;

- (UIButton* (^)(NSAttributedString* attributedString))sk_setAttributedStringNormal;

- (UIButton* (^)(NSAttributedString* attributedString))sk_setAttributedStringHightlight;

- (UIButton* (^)(NSAttributedString* attributedString))sk_setAttributedStringSelect;

- (UIButton* (^)(NSAttributedString* attributedString,UIControlState state))sk_setAttributedString;

- (UIButton* (^)(UIImage* image))sk_setImageNormal;

- (UIButton* (^)(UIImage* image))sk_setImageHightlight;

- (UIButton* (^)(UIImage* image))sk_setImageSelect;

- (UIButton* (^)(UIImage* image,UIControlState state))sk_setImage;

- (UIButton* (^)(UIImage* image))sk_setBackgroundImageNormal;

- (UIButton* (^)(UIImage* image))sk_setBackgroundImageHightlight;

- (UIButton* (^)(UIImage* image))sk_setBackgroundImageSelect;

- (UIButton* (^)(UIImage* image,UIControlState state))sk_setBackgroundImage;

@end
