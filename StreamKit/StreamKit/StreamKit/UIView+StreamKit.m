//
//  UIView+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/15.
//  Copyright © 2016年 苏南. All rights reserved.
//

#import "UIView+StreamKit.h"
#import <objc/runtime.h>

@implementation UIView (StreamKit)

+ (UIView* (^)(CGRect frame))sk_init
{
    return ^ UIView* (CGRect frame) {
        UIView* view = [[UIView alloc] initWithFrame:frame];
        return view;
    };
}

- (UIView* (^) (NSInteger tag))sk_tag
{
    return ^ UIView* (NSInteger tag) {
        self.tag = tag;
        return self;
    };
}

- (UIView* (^)(BOOL userInteractionEnabled))sk_userInteractionEnabled
{
    return ^ UIView* (BOOL userInteractionEnabled) {
        return ({self.userInteractionEnabled = userInteractionEnabled;self;});
    };
}

@end

@implementation UIView (StreamGeometry)

+ (UIView* (^)(CGRect frame))sk_init
{
    return ^ UIView* (CGRect frame) {
        UIView* view = [[UIView alloc] initWithFrame:frame];
        return view;
    };
}

- (UIView* (^)(CGRect frame))sk_frame
{
    return  ^ UIView* (CGRect frame) {
        self.frame = frame;
        return self;
    };
}

- (UIView* (^)(CGFloat x))sk_x
{
    return  ^ UIView* (CGFloat x) {
        CGRect frame = self.frame;
        frame.origin.x = x;
        return self.sk_frame(frame);
    };
}

- (UIView* (^)(CGFloat y))sk_y
{
    return  ^ UIView* (CGFloat y) {
        CGRect frame = self.frame;
        frame.origin.y = y;
        return self.sk_frame(frame);
    };
}

- (UIView* (^)(CGFloat width))sk_width
{
    return  ^ UIView* (CGFloat width) {
        CGRect frame = self.frame;
        frame.size.width = width;
        return self.sk_frame(frame);
    };
}

- (UIView* (^)(CGFloat height))sk_height
{
    return ^ UIView* (CGFloat height) {
        CGRect frame = self.frame;
        frame.size.height = height;
        return self.sk_frame(frame);
    };
}

- (UIView* (^)(CGSize size))sk_size
{
    return ^ UIView* (CGSize size) {
        return self.sk_frame(({CGRect frame = self.frame;frame.size = size;frame;}));
    };
}

- (UIView* (^)(CGRect bounds))sk_bounds
{
    return ^ UIView* (CGRect bounds) {
        self.bounds = bounds;
        return self;
    };
}

- (UIView* (^)(CGPoint point))sk_center
{
    return ^ UIView* (CGPoint point) {
        self.center = point;
        return self;
    };
}

- (UIView* (^)(CGFloat centerX))sk_centerX
{
    return ^ UIView* (CGFloat centerX) {
        return self.sk_center(({CGPoint center = self.center;center.x = centerX;center;}));
    };
}

- (UIView* (^)(CGFloat centerY))sk_centerY
{
    return ^ UIView* (CGFloat centerY) {
        return self.sk_center(({CGPoint center = self.center;center.y = centerY;center;}));
    };
}

- (UIView* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews
{
    return ^ UIView* (BOOL autoresizesSubviews) {
        return ({self.autoresizesSubviews = autoresizesSubviews;self;});
    };
}

- (UIView* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask
{
    return ^ UIView* (UIViewAutoresizing autoresizingMask) {
        return ({self.autoresizingMask = autoresizingMask;self;});
    };
}

@end

@implementation UIView (StreamRendering)

- (UIView* (^)(UIColor* backgroundColor))sk_backgroundColor
{
    return ^ UIView* (UIColor* backgroundColor) {
        self.backgroundColor = backgroundColor;
        return self;
    };
}

- (UIView* (^) (BOOL masksToBounds))sk_masksToBounds
{
    return ^ UIView* (BOOL masksToBounds) {
        self.layer.masksToBounds = masksToBounds;
        return self;
    };
}

- (UIView* (^) (CGFloat cornerRadius))sk_cornerRadius
{
    return ^ UIView* (CGFloat cornerRadius) {
        self.layer.cornerRadius = cornerRadius;
        return self;
    };
}

- (UIView* (^)(CGFloat alpha))sk_alpha
{
    return ^ UIView* (CGFloat alpha) {
        self.alpha = alpha;
        return self;
    };
}

- (UIView* (^)(BOOL opaque))sk_opaque
{
    return ^ UIView* (BOOL opaque) {
        return ({self.opaque = opaque;self;});
    };
}

- (UIView* (^)(BOOL hidden))sk_hidden
{
    return ^ UIView* (BOOL hidden) {
        self.hidden = hidden;
        return self;
    };
}

- (UIView* (^)(UIViewContentMode mode))sk_contentMode
{
    return ^ UIView* (UIViewContentMode mode) {
        return ({self.contentMode = mode;self;});
    };
}

- (UIView* (^)(BOOL clipsToBounds))sk_clipsToBounds
{
    return ^ UIView* (BOOL clipsToBounds) {
        return ({self.clipsToBounds = clipsToBounds;self;});
    };
}

- (UIView* (^)(UIColor* tintColor))sk_tintColor
{
    return ^ UIView* (UIColor* tintColor) {
        return ({self.tintColor = tintColor;self;});
    };
}

@end

@implementation UIView (StreamGestureRecognizers)

- (UIView* (^)(UIGestureRecognizer* gestureRecognizers))sk_addGestureRecognizer
{
    return ^ UIView* (UIGestureRecognizer* gestureRecognizers) {
        return ({[self addGestureRecognizer:gestureRecognizers];self;});
    };
}

- (UIView* (^)(UIGestureRecognizer* gestureRecognizers))sk_removeGestureRecognizer
{
    return ^ UIView* (UIGestureRecognizer* gestureRecognizers) {
        return ({[self removeGestureRecognizer:gestureRecognizers];self;});
    };
}

@end

static const void* SKAction_Key = &SKAction_Key;
@implementation UIView (StreamResponder)

- (UIView* (^)(dispatch_block_t block))sk_addSimpleClickAction
{
    return ^ UIView* (dispatch_block_t block) {
        if (block) {
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(simpleClickAction:)];
            objc_setAssociatedObject(self, (__bridge const void *)(tap), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
            return self.sk_userInteractionEnabled(YES).sk_addGestureRecognizer(tap);
        }
        return self;
    };
}

- (UIView* (^)(void(^block)(__kindof UIView* view)))sk_addParamClickAction
{
    return ^ UIView* (void (^block)(__kindof UIView* view)) {
        if (block) {
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(paramClickAction:)];
            objc_setAssociatedObject(self, (__bridge const void *)(tap), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
            return self.sk_userInteractionEnabled(YES).sk_addGestureRecognizer(tap);
        }
        return self;
    };
}

#pragma private
- (void)simpleClickAction:(UITapGestureRecognizer*)tap
{
    dispatch_block_t block = objc_getAssociatedObject(self, (__bridge const void *)(tap));
    if (block) block();
}

- (void)paramClickAction:(UITapGestureRecognizer*)tap
{
    void(^block)(__kindof UIView* view) = objc_getAssociatedObject(self, (__bridge const void *)(tap));
    if (block) block(tap.view);
}

@end
