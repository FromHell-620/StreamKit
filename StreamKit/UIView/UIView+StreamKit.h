//
//  UIView+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/15.
//  Copyright © 2016年 苏南. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (StreamKit)

/**
 Creates a new view by the given frame.
 */
+ (UIView* (^)(CGRect frame))sk_init;

/**
 Set tag.
 */
- (UIView* (^)(NSInteger tag))sk_tag;

/**
 Set userInteractionEnabled.
 */
- (UIView* (^)(BOOL userInteractionEnabled))sk_userInteractionEnabled;

@end

@interface UIView (StreamGeometry)

/**
 Set frame.
 */
- (UIView* (^)(CGRect frame))sk_frame;

/**
 Set frame.origin.x.
 */
- (UIView* (^)(CGFloat x))sk_x;

/**
 Set frame.origin.y.
 */
- (UIView* (^)(CGFloat y))sk_y;

/**
 Set frame.size.width.
 */
- (UIView* (^)(CGFloat width))sk_width;

/**
 Set frame.size.height.
 */
- (UIView* (^)(CGFloat height))sk_height;

/**
 Set frame.size.
 */
- (UIView* (^)(CGSize size))sk_size;

/**
 Set bounds.
 */
- (UIView* (^)(CGRect bounds))sk_bounds;

/**
 Set center.
 */
- (UIView* (^)(CGPoint point))sk_center;

/**
 Set center.x.
 */
- (UIView* (^)(CGFloat centerX))sk_centerX;

/**
 Set center.y.
 */
- (UIView* (^)(CGFloat centerY))sk_centerY;

/**
 Set autoresizesSubviews.
 */
- (UIView* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

/**
 Set autoresizingMask.
 */
- (UIView* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

@end

@interface UIView (StreamRendering)

/**
 Set backgroundColor.
 */
- (UIView* (^)(UIColor* backgroundColor))sk_backgroundColor;

/**
 Set layer's masksToBounds.
 */
- (UIView* (^) (BOOL masksToBounds))sk_masksToBounds;

/**
 Set layer's cornerRadius.
 */
- (UIView* (^) (CGFloat cornerRadius))sk_cornerRadius;

/**
 Set alpha.
 */
- (UIView* (^)(CGFloat alpha))sk_alpha;

/**
 Set opaque.
 */
- (UIView* (^)(BOOL opaque))sk_opaque;

/**
 Set hidden.
 */
- (UIView* (^)(BOOL hidden))sk_hidden;

/**
 Set contentMode.
 */
- (UIView* (^)(UIViewContentMode mode))sk_contentMode;

/**
 Set clipsToBounds.
 */
- (UIView* (^)(BOOL clipsToBounds))sk_clipsToBounds;

/**
 Set tintColor.
 */
- (UIView* (^)(UIColor* tintColor))sk_tintColor;

@end

@interface UIView (StreamGestureRecognizers)

/**
 Adds a gestureRecognizers.
 */
- (UIView* (^)(UIGestureRecognizer* gestureRecognizers))sk_addGestureRecognizer;

/**
 Remove a gestureRecognizers.
 */
- (UIView* (^)(UIGestureRecognizer* gestureRecognizers))sk_removeGestureRecognizer;

@end

@interface UIView (StreamResponder)

/**
 Adds a tap-gesture.
 @code
 self.sk_addSimpleClickAction(^{
    your code;
 });
 @endcode
 @return a block which receive an event block.
 */
- (UIView* (^)(dispatch_block_t block))sk_addSimpleClickAction;

/**
 Adds a tap-gesture.
 @code
 self.sk_addParamClickAction(^(UIView* view){
    your code;
 });
 @endcode
 @return a block which receive an event block.
         the event block takes a parameter.
 */
- (UIView* (^)(void(^block)(__kindof UIView* view)))sk_addParamClickAction;

@end
