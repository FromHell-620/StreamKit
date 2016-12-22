//
//  UIImageView+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (StreamSuper)

- (UIImageView* (^)(NSInteger tag))sk_tag;

- (UIImageView* (^)(BOOL userInteractionEnabled))sk_userInteractionEnabled;

- (UIImageView* (^)(CGRect frame))sk_frame;

- (UIImageView* (^)(CGFloat x))sk_x;

- (UIImageView* (^)(CGFloat y))sk_y;

- (UIImageView* (^)(CGFloat width))sk_width;

- (UIImageView* (^)(CGFloat height))sk_height;

- (UIImageView* (^)(CGSize size))sk_size;

- (UIImageView* (^)(CGRect bounds))sk_bounds;

- (UIImageView* (^)(CGPoint point))sk_center;

- (UIImageView* (^)(CGFloat centerX))sk_centerX;

- (UIImageView* (^)(CGFloat centerY))sk_centerY;

- (UIImageView* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UIImageView* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UIImageView* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UIImageView* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UIImageView* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UIImageView* (^)(CGFloat alpha))sk_alpha;

- (UIImageView* (^)(BOOL opaque))sk_opaque;

- (UIImageView* (^)(BOOL hidden))sk_hidden;

- (UIImageView* (^)(UIViewContentMode mode))sk_contentMode;

- (UIImageView* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UIImageView* (^)(UIColor* tintColor))sk_tintColor;

- (UIImageView* (^)(UIGestureRecognizer* gestureRecognizers))sk_addGestureRecognizer;

- (UIImageView* (^)(UIGestureRecognizer* gestureRecognizers))sk_removeGestureRecognizer;

- (UIImageView* (^)(dispatch_block_t block))sk_addSimpleClickAction;

- (UIImageView* (^)(void(^block)(__kindof UIView* view)))sk_addParamClickAction;

@end

@interface UIImageView (StreamKit)

+ (UIImageView* (^)(CGRect frame))sk_initWithFrame;

+ (UIImageView* (^)(UIImage* image))sk_initWithImage;

- (UIImageView* (^)(UIImage* image))sk_image;

- (UIImageView* (^)(UIImage* highlightedImage))sk_highlightedImage;

- (UIImageView* (^)(BOOL highlighted))sk_highlighted;

- (UIImageView* (^)(NSArray<UIImage*>* animationImages))sk_animationImages;

- (UIImageView* (^)(NSArray<UIImage*>* highlightedAnimationImages))sk_highlightedAnimationImages;

- (UIImageView* (^)(NSTimeInterval animationDuration))sk_animationDuration;

- (UIImageView* (^)(NSInteger animationRepeatCount))sk_animationRepeatCount;

@end
