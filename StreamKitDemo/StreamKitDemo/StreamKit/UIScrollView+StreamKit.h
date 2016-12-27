//
//  UIScrollView+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/24.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (StreamSuper)

- (UIScrollView* (^)(NSInteger tag))sk_tag;

- (UIScrollView* (^)(BOOL userInteractionEnabled))sk_userInteractionEnabled;

- (UIScrollView* (^)(CGRect frame))sk_frame;

- (UIScrollView* (^)(CGFloat x))sk_x;

- (UIScrollView* (^)(CGFloat y))sk_y;

- (UIScrollView* (^)(CGFloat width))sk_width;

- (UIScrollView* (^)(CGFloat height))sk_height;

- (UIScrollView* (^)(CGSize size))sk_size;

- (UIScrollView* (^)(CGRect bounds))sk_bounds;

- (UIScrollView* (^)(CGPoint point))sk_center;

- (UIScrollView* (^)(CGFloat centerX))sk_centerX;

- (UIScrollView* (^)(CGFloat centerY))sk_centerY;

- (UIScrollView* (^)(BOOL autoresizesSubviews))sk_autoresizesSubviews;

- (UIScrollView* (^)(UIViewAutoresizing autoresizingMask))sk_autoresizingMask;

- (UIScrollView* (^)(UIColor* backgroundColor))sk_backgroundColor;

- (UIScrollView* (^) (BOOL masksToBounds))sk_masksToBounds;

- (UIScrollView* (^) (CGFloat cornerRadius))sk_cornerRadius;

- (UIScrollView* (^)(CGFloat alpha))sk_alpha;

- (UIScrollView* (^)(BOOL opaque))sk_opaque;

- (UIScrollView* (^)(BOOL hidden))sk_hidden;

- (UIScrollView* (^)(UIViewContentMode mode))sk_contentMode;

- (UIScrollView* (^)(BOOL clipsToBounds))sk_clipsToBounds;

- (UIScrollView* (^)(UIColor* tintColor))sk_tintColor;

@end

@interface UIScrollView (StreamKit)

+ (UIScrollView* (^)(CGRect frame))sk_init;

- (UIScrollView* (^)(CGPoint contentOffset))sk_contentOffset;

- (UIScrollView* (^)(CGPoint contentOffset,BOOL animated))sk_contentOffsetWithAnimated;

- (UIScrollView* (^)(CGSize contentSize))sk_contentSize;

- (UIScrollView* (^)(UIEdgeInsets contentInset))sk_contentInset;

- (UIScrollView* (^)(id<UIScrollViewDelegate> delegate))sk_delegate;

- (UIScrollView* (^)(BOOL directionalLockEnabled))sk_directionalLockEnabled;

- (UIScrollView* (^)(BOOL bounces))sk_bounces;

- (UIScrollView* (^)(BOOL alwaysBounceVertical))sk_alwaysBounceVertical;

- (UIScrollView* (^)(BOOL alwaysBounceHorizontal))sk_alwaysBounceHorizontal;

- (UIScrollView* (^)(BOOL pagingEnabled))sk_pagingEnabled;

- (UIScrollView* (^)(BOOL scrollEnabled))sk_scrollEnabled;

- (UIScrollView* (^)(BOOL showsHorizontalScrollIndicator))sk_showsHorizontalScrollIndicator;

- (UIScrollView* (^)(BOOL showsVerticalScrollIndicator))sk_showsVerticalScrollIndicator;

- (UIScrollView* (^)(UIEdgeInsets scrollIndicatorInsets))sk_scrollIndicatorInsets;

- (UIScrollView* (^)(CGFloat minimumZoomScale))sk_minimumZoomScale;

- (UIScrollView* (^)(CGFloat maximumZoomScale))sk_maximumZoomScale;

- (UIScrollView* (^)(CGFloat zoomScale))sk_zoomScale;

- (UIScrollView* (^)(CGFloat zoomScale,BOOL animated))sk_zoomScaleWithAnimated;

- (UIScrollView* (^)(BOOL bouncesZoom))sk_bouncesZoom;

- (UIScrollView* (^)(BOOL scrollsToTop))sk_scrollsToTop;

@end

@interface UIScrollView (StreamDelegate)

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidScroll;

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidZoom;

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewWillBeginDragging;

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,CGPoint velocity,CGPoint* targetContentOffset)))sk_scrollViewWillEndDraggingWithVelocityAndTargetContentOffset;

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,BOOL decelerate)))sk_scrollViewDidEndDraggingWithDecelerate;

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewWillBeginDecelerating;

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidEndDecelerating;

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidEndScrollingAnimation;

- (UIScrollView* (^)(UIView* (^block)(UIScrollView* scrollView)))sk_viewForZoomingInScrollView;

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,UIView* view)))sk_scrollViewWillBeginZoomingWithView;

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,UIView* view,CGFloat scale)))sk_scrollViewDidEndZoomingWithView;

- (UIScrollView* (^)(BOOL(^block)(UIScrollView* scrollView)))sk_scrollViewShouldScrollToTop;

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidScrollToTop;

@end
