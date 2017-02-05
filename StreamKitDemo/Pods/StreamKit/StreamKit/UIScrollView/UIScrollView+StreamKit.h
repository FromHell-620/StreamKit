//
//  UIScrollView+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/24.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
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

/**
 Creats a new scrollView by the given frame.
 @code
 UIScrollView* scrollView = UIScrollView.sk_init(frame);
 @endcode
 */
+ (UIScrollView* (^)(CGRect frame))sk_init;

/**
 Set contentOffset.
 */
- (UIScrollView* (^)(CGPoint contentOffset))sk_contentOffset;

/**
 Set contentOffsetWithAnimated.
 */
- (UIScrollView* (^)(CGPoint contentOffset,BOOL animated))sk_contentOffsetWithAnimated;

/**
 Set contentSize.
 */
- (UIScrollView* (^)(CGSize contentSize))sk_contentSize;

/**
 Set contentInset.
 */
- (UIScrollView* (^)(UIEdgeInsets contentInset))sk_contentInset;

/**
 Set delegate.
 */
- (UIScrollView* (^)(id<UIScrollViewDelegate> delegate))sk_delegate;

/**
 Set directionalLockEnabled.
 */
- (UIScrollView* (^)(BOOL directionalLockEnabled))sk_directionalLockEnabled;

/**
 Set bounces.
 */
- (UIScrollView* (^)(BOOL bounces))sk_bounces;

/**
 Set alwaysBounceVertical.
 */
- (UIScrollView* (^)(BOOL alwaysBounceVertical))sk_alwaysBounceVertical;

/**
 Set alwaysBounceHorizontal.
 */
- (UIScrollView* (^)(BOOL alwaysBounceHorizontal))sk_alwaysBounceHorizontal;

/**
 Set pagingEnabled.
 */
- (UIScrollView* (^)(BOOL pagingEnabled))sk_pagingEnabled;

/**
 Set scrollEnabled.
 */
- (UIScrollView* (^)(BOOL scrollEnabled))sk_scrollEnabled;

/**
 Set showsHorizontalScrollIndicator.
 */
- (UIScrollView* (^)(BOOL showsHorizontalScrollIndicator))sk_showsHorizontalScrollIndicator;

/**
 Set showsVerticalScrollIndicator.
 */
- (UIScrollView* (^)(BOOL showsVerticalScrollIndicator))sk_showsVerticalScrollIndicator;

/**
 Set scrollIndicatorInsets.
 */
- (UIScrollView* (^)(UIEdgeInsets scrollIndicatorInsets))sk_scrollIndicatorInsets;

/**
 Set minimumZoomScale.
 */
- (UIScrollView* (^)(CGFloat minimumZoomScale))sk_minimumZoomScale;

/**
 Set maximumZoomScale.
 */
- (UIScrollView* (^)(CGFloat maximumZoomScale))sk_maximumZoomScale;

/**
 Set zoomScale.
 */
- (UIScrollView* (^)(CGFloat zoomScale))sk_zoomScale;

/**
 Set zoomScaleWithAnimated.
 */
- (UIScrollView* (^)(CGFloat zoomScale,BOOL animated))sk_zoomScaleWithAnimated;

/**
 Set bouncesZoom.
 */
- (UIScrollView* (^)(BOOL bouncesZoom))sk_bouncesZoom;

/**
 Set scrollsToTop.
 */
- (UIScrollView* (^)(BOOL scrollsToTop))sk_scrollsToTop;

@end

@interface UIScrollView (StreamDelegate)

/**
 Instead of the 'scrollViewDidScroll:'.
 */
- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidScroll;

/**
 Instead of the 'scrollViewDidZoom:'.
 */
- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidZoom;

/**
 Instead of the 'scrollViewWillBeginDragging:'.
 */
- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewWillBeginDragging;

/**
 Instead of the 'scrollViewWillEndDragging:withVelocity:targetContentOffset:'.
 */
- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,CGPoint velocity,CGPoint* targetContentOffset)))sk_scrollViewWillEndDraggingWithVelocityAndTargetContentOffset;

/**
 Instead of the 'scrollViewDidEndDragging:willDecelerate:'.
 */
- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,BOOL decelerate)))sk_scrollViewDidEndDraggingWithDecelerate;

/**
 Instead of the 'scrollViewWillBeginDecelerating:'.
 */
- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewWillBeginDecelerating;

/**
 Instead of the 'scrollViewDidEndDecelerating:'.
 */
- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidEndDecelerating;

/**
 Instead of the 'scrollViewDidEndScrollingAnimation:'.
 */
- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidEndScrollingAnimation;

/**
 Instead of the 'viewForZoomingInScrollView:'.
 */
- (UIScrollView* (^)(UIView* (^block)(UIScrollView* scrollView)))sk_viewForZoomingInScrollView;

/**
 Instead of the 'scrollViewWillBeginZooming:withView:'.
 */
- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,UIView* view)))sk_scrollViewWillBeginZoomingWithView;

/**
 Instead of the 'scrollViewDidEndZooming:withView:atScale:'.
 */
- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,UIView* view,CGFloat scale)))sk_scrollViewDidEndZoomingWithView;

/**
 Instead of the 'scrollViewShouldScrollToTop:'.
 */
- (UIScrollView* (^)(BOOL(^block)(UIScrollView* scrollView)))sk_scrollViewShouldScrollToTop;

/**
 Instead of the 'scrollViewDidScrollToTop:'.
 */
- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidScrollToTop;

@end
