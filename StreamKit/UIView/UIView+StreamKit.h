//
//  UIView+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/15.
//  Copyright © 2016年 苏南. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (StreamKit)

+ (UIView* (^)(CGRect frame))sk_init;

- (UIView* (^)(NSInteger tag))sk_tag;

- (UIView* (^)(BOOL userInteractionEnabled))sk_userInteractionEnabled;

@end

@interface UIView (StreamGeometry)

- (UIView* (^)(CGRect frame))sk_frame;

- (UIView* (^)(CGFloat x))sk_x;

- (UIView* (^)(CGFloat y))sk_y;

- (UIView* (^)(CGFloat width))sk_width;

- (UIView* (^)(CGFloat height))sk_height;

- (UIView* (^)(CGSize size))sk_size;

- (UIView* (^)(CGRect bounds))sk_bounds;

- (UIView* (^)(CGPoint point))sk_center;

- (UIView* (^)(CGFloat centerX))sk_centerX;

- (UIView* (^)(CGFloat centerY))sk_centerY;

- (UIView* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UIView* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

@end

@interface UIView (StreamRendering)

- (UIView* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UIView* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UIView* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UIView* (^)(CGFloat alpha))sk_alpha;

- (UIView* (^)(BOOL opaque))sk_opaque;

- (UIView* (^)(BOOL hidden))sk_hidden;

- (UIView* (^)(UIViewContentMode mode))sk_contentMode;

- (UIView* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UIView* (^)(UIColor* tintColor))sk_tintColor;

@end

@interface UIView (StreamGestureRecognizers)

- (UIView* (^)(UIGestureRecognizer* gestureRecognizers))sk_addGestureRecognizer;

- (UIView* (^)(UIGestureRecognizer* gestureRecognizers))sk_removeGestureRecognizer;

@end

@interface UIView (StreamResponder)

- (UIView* (^)(dispatch_block_t block))sk_addSimpleClickAction;

- (UIView* (^)(void(^block)(__kindof UIView* view)))sk_addParamClickAction;

@end
