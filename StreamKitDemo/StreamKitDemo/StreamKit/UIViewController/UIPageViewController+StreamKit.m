//
//  UIPageViewController+StreamKit.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIPageViewController+StreamKit.h"

@implementation UIPageViewController (StreamKit)

+ (UIPageViewController* (^)(UIPageViewControllerTransitionStyle style,UIPageViewControllerNavigationOrientation navigationOrientation,NSDictionary<NSString *, id> * options))sk_init
{
    return ^ UIPageViewController* (UIPageViewControllerTransitionStyle style,UIPageViewControllerNavigationOrientation navigationOrientation,NSDictionary<NSString *, id> * options) {
        return [[UIPageViewController alloc] initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
    };
}

- (UIPageViewController* (^)(id<UIPageViewControllerDelegate> delegate))sk_delegate
{
    return ^ UIPageViewController* (id<UIPageViewControllerDelegate> delegate) {
        return ({self.delegate = delegate;self;});
    };
}

- (UIPageViewController* (^)(id<UIPageViewControllerDataSource> dataSource))sk_dataSource
{
    return ^ UIPageViewController* (id<UIPageViewControllerDataSource> dataSource) {
        return ({self.dataSource = dataSource;self;});
    };
}

- (UIPageViewController* (^)(BOOL doubleSided))sk_doubleSided
{
    return ^ UIPageViewController* (BOOL doubleSided) {
        return ({self.doubleSided = doubleSided;self;});
    };
}

- (UIPageViewController* (^)(NSArray<UIViewController *> * viewControllers,UIPageViewControllerNavigationDirection direction,BOOL animated,void(^completion)(BOOL finished)))sk_setViewControllers
{
    return ^ UIPageViewController* (NSArray<UIViewController *> * viewControllers,UIPageViewControllerNavigationDirection direction,BOOL animated,void(^completion)(BOOL finished)) {
        return ({[self setViewControllers:viewControllers direction:direction animated:animated completion:completion];self;});
    };
}

@end
