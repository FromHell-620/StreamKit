//
//  UITextField+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (StreamSuper)

#pragma mark- UIView
- (UITextField* (^)(CGRect frame))sk_frame;

- (UITextField* (^)(CGFloat x))sk_x;

- (UITextField* (^)(CGFloat y))sk_y;

- (UITextField* (^)(CGFloat width))sk_width;

- (UITextField* (^)(CGFloat height))sk_height;

- (UITextField* (^)(CGSize size))sk_size;

- (UITextField* (^)(CGRect bounds))sk_bounds;

- (UITextField* (^)(CGPoint point))sk_center;

- (UITextField* (^)(CGFloat centerX))sk_centerX;

- (UITextField* (^)(CGFloat centerY))sk_centerY;

- (UITextField* (^)(NSInteger tag))sk_tag;

- (UITextField* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UITextField* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UITextField* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UITextField* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UITextField* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UITextField* (^)(CGFloat alpha))sk_alpha;

- (UITextField* (^)(BOOL opaque))sk_opaque;

- (UITextField* (^)(BOOL hidden))sk_hidden;

- (UITextField* (^)(UIViewContentMode mode))sk_contentMode;

- (UITextField* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UITextField* (^)(UIColor* tintColor))sk_tintColor;

#pragma mark- UIControl

- (UITextField* (^)(BOOL enabled))sk_enabled;

- (UITextField* (^)(BOOL selected))sk_selected;

- (UITextField* (^)(BOOL highlighted))sk_highlighted;

- (UITextField* (^)(UIControlContentVerticalAlignment contentVerticalAlignment))lm_contentVerticalAlignment;

- (UITextField* (^)(UIControlContentHorizontalAlignment contentHorizontalAlignment))lm_contentHorizontalAlignment;

- (UITextField* (^)(UIControlEvents controlEvents,void(^block)(__kindof UITextField* target)))sk_addEventBlock;

- (UITextField* (^)(UIControlEvents controlEvents))sk_removeEventBlock;

- (UITextField* (^)())sk_removeAllEventBlock;

@end

@interface UITextField (StreamKit)

+ (UITextField* (^)(CGRect frame))sk_init;

- (UITextField* (^)(NSString* text))sk_text;

- (UITextField* (^)(NSAttributedString* attributedText))sk_attributedText;

- (UITextField* (^)(UIColor* textColor))sk_textColor;

- (UITextField* (^)(NSInteger fontSize))sk_fontSize;

- (UITextField* (^)(UIFont* font))sk_font;

- (UITextField* (^)(NSTextAlignment textAlignment))sk_textAlignment;

- (UITextField* (^)(UITextBorderStyle borderStyle))sk_borderStyle;

- (UITextField* (^)(NSDictionary<NSString*,id>* defaultTextAttributes))sk_defaultTextAttributes;

- (UITextField* (^)(NSString* placeholder))sk_placeholder;

- (UITextField* (^)(NSAttributedString* attributedPlaceholder))sk_attributedPlaceholder;

- (UITextField* (^)(BOOL clearsOnBeginEditing))sk_clearsOnBeginEditing;

- (UITextField* (^)(BOOL adjustsFontSizeToFitWidth))sk_adjustsFontSizeToFitWidth;

- (UITextField* (^)(CGFloat minimumFontSize))sk_minimumFontSize;

- (UITextField* (^)(id<UITextFieldDelegate> delegate))sk_delegate;

- (UITextField* (^)(UIImage* background))sk_background;

- (UITextField* (^)(UIImage* disabledBackground))sk_disabledBackground;

- (UITextField* (^)(BOOL allowsEditingTextAttributes))sk_allowsEditingTextAttributes;

- (UITextField* (^)(NSDictionary<NSString*,id>* typingAttributes))sk_typingAttributes;

- (UITextField* (^)(UITextFieldViewMode clearButtonMode))sk_clearButtonMode;

- (UITextField* (^)(UIView* leftView))sk_leftView;

- (UITextField* (^)(UITextFieldViewMode leftViewMode))sk_leftViewMode;

- (UITextField* (^)(UIView* rightView))sk_rightView;

- (UITextField* (^)(UITextFieldViewMode rightViewMode))sk_rightViewMode;

@end

@interface UITextField (StreamDelegate)

- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldBeginEditing;

- (UITextField* (^)(void(^block)(UITextField* textField)))sk_textFieldDidBeginEditing;

- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldEndEditing;

- (UITextField* (^)(void(^block)(UITextField* textField)))sk_textFieldDidEndEditing;

- (UITextField* (^)(void(^block)(UITextField* textField,UITextFieldDidEndEditingReason reason)))sk_textFieldDidEndEditingWithReaseon;

- (UITextField* (^)(BOOL(^block)(UITextField* textField,NSRange range,NSString* string)))sk_textFieldShouldChangeCharactersInRange;

- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldClear;

- (UITextField* (^)(BOOL(^block)(UITextField* textField)))sk_textFieldShouldReturn;

@end
