//
//  UIPageViewController+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPageViewController (StreamKit)

+ (UIPageViewController* (^)(UIPageViewControllerTransitionStyle style,UIPageViewControllerNavigationOrientation navigationOrientation,NSDictionary<NSString *, id> * options))sk_init;

- (UIPageViewController* (^)(id<UIPageViewControllerDelegate> delegate))sk_delegate;

- (UIPageViewController* (^)(id<UIPageViewControllerDataSource> dataSource))sk_dataSource;

- (UIPageViewController* (^)(BOOL doubleSided))sk_doubleSided;

- (UIPageViewController* (^)(NSArray<UIViewController *> * viewControllers,UIPageViewControllerNavigationDirection direction,BOOL animated,void(^completion)(BOOL finished)))sk_setViewControllers;

@end

