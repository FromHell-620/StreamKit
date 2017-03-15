//
//  UIScrollView+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/24.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIScrollView+StreamKit.h"
#import "NSObject+StreamKit.h"
@import ObjectiveC.runtime;
@import ObjectiveC.message;

@implementation UIScrollView (StreamKit)

+ (UIScrollView* (^)(CGRect frame))sk_init
{
    return ^ UIScrollView* (CGRect frame) {
        return [[UIScrollView alloc] initWithFrame:frame];
    };
}

- (UIScrollView* (^)(CGPoint contentOffset))sk_contentOffset
{
    return ^ UIScrollView* (CGPoint contentOffset) {
        return self.sk_contentOffsetWithAnimated(contentOffset,NO);
    };
}

- (UIScrollView* (^)(CGPoint contentOffset,BOOL animated))sk_contentOffsetWithAnimated
{
    return ^ UIScrollView*(CGPoint contentOffset,BOOL animated) {
        return ({[self setContentOffset:contentOffset animated:animated];self;});
    };
}

- (UIScrollView* (^)(CGSize contentSize))sk_contentSize
{
    return ^ UIScrollView* (CGSize contentSize) {
        return ({self.contentSize = contentSize;self;});
    };
}

- (UIScrollView* (^)(UIEdgeInsets contentInset))sk_contentInset
{
    return ^ UIScrollView* (UIEdgeInsets contentInset) {
        return ({self.contentInset = contentInset;self;});
    };
}

- (UIScrollView* (^)(id<UIScrollViewDelegate> delegate))sk_delegate
{
    return ^ UIScrollView* (id<UIScrollViewDelegate> delegate) {
        return ({self.delegate = delegate;self;});
    };
}

- (UIScrollView* (^)(BOOL directionalLockEnabled))sk_directionalLockEnabled
{
    return ^ UIScrollView* (BOOL directionalLockEnabled) {
        return ({self.directionalLockEnabled = directionalLockEnabled;self;});
    };
}

- (UIScrollView* (^)(BOOL bounces))sk_bounces
{
    return ^ UIScrollView* (BOOL bounces) {
        return ({self.bounces = bounces;self;});
    };
}

- (UIScrollView* (^)(BOOL alwaysBounceVertical))sk_alwaysBounceVertical
{
    return ^ UIScrollView* (BOOL alwaysBounceVertical) {
        return ({self.alwaysBounceVertical = alwaysBounceVertical;self;});
    };
}

- (UIScrollView* (^)(BOOL alwaysBounceHorizontal))sk_alwaysBounceHorizontal
{
    return ^ UIScrollView* (BOOL alwaysBounceHorizontal) {
        return ({self.alwaysBounceVertical = alwaysBounceHorizontal;self;});
    };
}

- (UIScrollView* (^)(BOOL pagingEnabled))sk_pagingEnabled
{
    return ^ UIScrollView* (BOOL pagingEnabled) {
        return ({self.pagingEnabled = pagingEnabled;self;});
    };
}

- (UIScrollView* (^)(BOOL scrollEnabled))sk_scrollEnabled
{
    return ^ UIScrollView* (BOOL scrollEnabled) {
        return ({self.scrollEnabled = scrollEnabled;self;});
    };
}

- (UIScrollView* (^)(BOOL showsHorizontalScrollIndicator))sk_showsHorizontalScrollIndicator
{
    return ^ UIScrollView* (BOOL showsHorizontalScrollIndicator) {
        return ({self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;self;});
    };
}

- (UIScrollView* (^)(BOOL showsVerticalScrollIndicator))sk_showsVerticalScrollIndicator
{
    return ^ UIScrollView* (BOOL showsVerticalScrollIndicator) {
        return ({self.showsVerticalScrollIndicator = showsVerticalScrollIndicator;self;});
    };
}

- (UIScrollView* (^)(UIEdgeInsets scrollIndicatorInsets))sk_scrollIndicatorInsets
{
    return ^ UIScrollView* (UIEdgeInsets scrollIndicatorInsets) {
        return ({self.scrollIndicatorInsets = scrollIndicatorInsets;self;});
    };
}

- (UIScrollView* (^)(CGFloat minimumZoomScale))sk_minimumZoomScale
{
    return ^ UIScrollView* (CGFloat minimumZoomScale) {
        return ({self.minimumZoomScale = minimumZoomScale;self;});
    };
}

- (UIScrollView* (^)(CGFloat maximumZoomScale))sk_maximumZoomScale
{
    return ^ UIScrollView* (CGFloat maximumZoomScale) {
        return ({self.maximumZoomScale = maximumZoomScale;self;});
    };
}

- (UIScrollView* (^)(CGFloat zoomScale))sk_zoomScale
{
    return ^ UIScrollView* (CGFloat zoomScale) {
        return self.sk_zoomScaleWithAnimated(zoomScale,NO);
    };
}

- (UIScrollView* (^)(CGFloat zoomScale,BOOL animated))sk_zoomScaleWithAnimated
{
    return ^ UIScrollView* (CGFloat zoomScale,BOOL animated) {
        return ({[self setZoomScale:zoomScale animated:animated];self;});
    };
}

- (UIScrollView* (^)(BOOL bouncesZoom))sk_bouncesZoom
{
    return ^ UIScrollView* (BOOL bouncesZoom) {
        return ({self.bouncesZoom = bouncesZoom;self;});
    };
}

- (UIScrollView* (^)(BOOL scrollsToTop))sk_scrollsToTop
{
    return ^ UIScrollView*(BOOL scrollsToTop) {
        return ({self.scrollsToTop = YES;self;});
    };
}

@end


@implementation UIScrollView (StreamDelegate)

+ (void)load
{
    NSDictionary* streamMethodAndProtocol = @{
                                @"scrollViewDidScroll:":@"sk_scrollViewDidScroll",
                                @"scrollViewDidZoom:":@"sk_scrollViewDidZoom",
                                @"scrollViewWillBeginDragging:":@"sk_scrollViewWillBeginDragging",
                                @"scrollViewWillEndDragging:withVelocity:targetContentOffset:":@"sk_scrollViewWillEndDraggingWithVelocityAndTargetContentOffset",
                                @"scrollViewDidEndDragging:willDecelerate:":@"sk_scrollViewDidEndDraggingWithDecelerate",
                                @"scrollViewWillBeginDecelerating:":@"sk_scrollViewWillBeginDecelerating",
                                @"scrollViewDidEndDecelerating:":@"sk_scrollViewDidEndDecelerating",
                                @"scrollViewDidEndScrollingAnimation:":@"sk_scrollViewDidEndScrollingAnimation",
                                @"viewForZoomingInScrollView:":@"sk_viewForZoomingInScrollView",
                                @"scrollViewWillBeginZooming:withView:":@"sk_scrollViewWillBeginZoomingWithView",
                                @"scrollViewDidEndZooming:withView:atScale:":@"sk_scrollViewDidEndZoomingWithView",
                                @"scrollViewShouldScrollToTop:":@"sk_scrollViewShouldScrollToTop",
                                @"scrollViewDidScrollToTop:":@"sk_scrollViewDidScrollToTop"
                                };
    [streamMethodAndProtocol enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        StreamSetImplementationToDelegateMethod(objc_getClass("UIScrollView"), @protocol(UIScrollViewDelegate), obj.UTF8String, key.UTF8String);
    }];
}

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidScroll
{
    return ^ UIScrollView* (void(^block)(UIScrollView* scrollView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidZoom
{
    return ^ UIScrollView* (void(^block)(UIScrollView* scrollView)) {
        StreamDelegateBindBlock(_cmd , self, block);
        return self;
    };
}

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewWillBeginDragging
{
    return ^ UIScrollView* (void(^block)(UIScrollView* scrollView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,CGPoint velocity,CGPoint* targetContentOffset)))sk_scrollViewWillEndDraggingWithVelocityAndTargetContentOffset
{
    return ^ UIScrollView* (void(^block)(UIScrollView* scrollView,CGPoint velocity,CGPoint* targetContentOffset)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,BOOL decelerate)))sk_scrollViewDidEndDraggingWithDecelerate
{
    return ^UIScrollView* (void(^block)(UIScrollView* scrollView,BOOL decelerate)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewWillBeginDecelerating
{
    return ^ UIScrollView* (void(^block)(UIScrollView* scrollView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidEndDecelerating
{
    return ^ UIScrollView* (void(^block)(UIScrollView* scollView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidEndScrollingAnimation
{
    return ^ UIScrollView* (void(^block)(UIScrollView* scrollView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIScrollView* (^)(UIView* (^block)(UIScrollView* scrollView)))sk_viewForZoomingInScrollView
{
    return ^ UIScrollView* (UIView* (^block)(UIScrollView* scrollView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,UIView* view)))sk_scrollViewWillBeginZoomingWithView
{
    return ^ UIScrollView* (void(^block)(UIScrollView* scrollView,UIView* view)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView,UIView* view,CGFloat scale)))sk_scrollViewDidEndZoomingWithView
{
    return ^ UIScrollView* (void(^block)(UIScrollView* scrollView,UIView* view,CGFloat scale)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIScrollView* (^)(BOOL(^block)(UIScrollView* scrollView)))sk_scrollViewShouldScrollToTop
{
    return ^ UIScrollView* (BOOL(^block)(UIScrollView* scrollView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIScrollView* (^)(void(^block)(UIScrollView* scrollView)))sk_scrollViewDidScrollToTop
{
    return ^ UIScrollView* (void(^block)(UIScrollView* scrollView)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

@end
