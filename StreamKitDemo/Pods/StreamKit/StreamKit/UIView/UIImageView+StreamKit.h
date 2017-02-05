//
//  UIImageView+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
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

/**
 Creates a new imageView by the given frame.
 @code
 UIImageView* imageView = UIImageView.sk_initWithFrame(frame);
 @endcode
 */
+ (UIImageView* (^)(CGRect frame))sk_initWithFrame;

/**
 Creates a new imageView by the given image.
 @code
 UIImageView* imageView = UIImageView.sk_initWithImage(image);
 @endcode
 */
+ (UIImageView* (^)(UIImage* image))sk_initWithImage;

/**
 Set image.
 @code
 self.sk_image(image);
 @endcode
 */
- (UIImageView* (^)(UIImage* image))sk_image;

/**
 Set highlightedImage.
 @code
 self.sk_highlightedImage(highlightedImage);
 @endcode
 */
- (UIImageView* (^)(UIImage* highlightedImage))sk_highlightedImage;

/**
 Set highlighted.
 @code
 self.sk_highlighted(highlighted);
 @endcode
 */
- (UIImageView* (^)(BOOL highlighted))sk_highlighted;

/**
 Set animationImages.
 @code
 self.sk_animationImages(animationImages);
 @endcode
 */
- (UIImageView* (^)(NSArray<UIImage*>* animationImages))sk_animationImages;

/**
 Set highlightedAnimationImages.
 @code
 self.sk_highlightedAnimationImages(highlightedAnimationImages);
 @endcode
 */
- (UIImageView* (^)(NSArray<UIImage*>* highlightedAnimationImages))sk_highlightedAnimationImages;

/**
 Set animationDuration.
 @code
 self.sk_animationDuration(animationDuration);
 @endcode
 */
- (UIImageView* (^)(NSTimeInterval animationDuration))sk_animationDuration;

/**
 Set animationRepeatCount.
 @code
 self.sk_animationRepeatCount(animationRepeatCount);
 @endcode
 */
- (UIImageView* (^)(NSInteger animationRepeatCount))sk_animationRepeatCount;

@end
