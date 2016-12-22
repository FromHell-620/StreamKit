//
//  UILabel+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (StreamSuper)

- (UILabel* (^)(NSInteger tag))sk_tag;

- (UILabel* (^)(BOOL userInteractionEnabled))sk_userInteractionEnabled;

- (UILabel* (^)(CGRect frame))sk_frame;

- (UILabel* (^)(CGFloat x))sk_x;

- (UILabel* (^)(CGFloat y))sk_y;

- (UILabel* (^)(CGFloat width))sk_width;

- (UILabel* (^)(CGFloat height))sk_height;

- (UILabel* (^)(CGSize size))sk_size;

- (UILabel* (^)(CGRect bounds))sk_bounds;

- (UILabel* (^)(CGPoint point))sk_center;

- (UILabel* (^)(CGFloat centerX))sk_centerX;

- (UILabel* (^)(CGFloat centerY))sk_centerY;

- (UILabel* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UILabel* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UILabel* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UILabel* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UILabel* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UILabel* (^)(CGFloat alpha))sk_alpha;

- (UILabel* (^)(BOOL opaque))sk_opaque;

- (UILabel* (^)(BOOL hidden))sk_hidden;

- (UILabel* (^)(UIViewContentMode mode))sk_contentMode;

- (UILabel* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UILabel* (^)(UIColor* tintColor))sk_tintColor;

- (UILabel* (^)(UIGestureRecognizer* gestureRecognizers))sk_addGestureRecognizer;

- (UILabel* (^)(UIGestureRecognizer* gestureRecognizers))sk_removeGestureRecognizer;

- (UILabel* (^)(dispatch_block_t block))sk_addSimpleClickAction;

- (UILabel* (^)(void(^block)(__kindof UIView* view)))sk_addParamClickAction;

@end

@interface UILabel (StreamKit)

+ (UILabel* (^)(CGRect frame))sk_init;

- (UILabel* (^)(NSString* text))sk_text;

- (UILabel* (^)(UIColor* textColor))sk_textColor;

- (UILabel* (^)(NSInteger fontSize))sk_fontSize;

- (UILabel* (^)(UIFont* font))sk_font;

- (UILabel* (^)(NSTextAlignment textAlignment))sk_textAlignment;

- (UILabel* (^)(NSLineBreakMode lineBreakMode))sk_lineBreakMode;

- (UILabel* (^)(NSAttributedString* attributedString))sk_attributedString;

- (UILabel* (^)(NSInteger numberOfLines))sk_numberOfLines;

- (UILabel* (^)(UIColor* highlightedTextColor))sk_highlightedTextColor;

- (UILabel* (^)(BOOL highlighted))sk_highlighted;

- (UILabel* (^)(CGFloat minimumScaleFactor))sk_minimumScaleFactor;

- (UILabel* (^)(BOOL adjustsFontSizeToFitWidth))sk_adjustsFontSizeToFitWidth;

- (UILabel* (^)(UIBaselineAdjustment baselineAdjustment))sk_baselineAdjustment;


@end
