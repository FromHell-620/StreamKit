//
//  UIPageViewController+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPageViewController (StreamKit)

/**
 Creates a new pageViewController by the given block.
 @code
 UIPageViewController* page = UIPageViewController.sk_init(style,navigationOrientation,options);
 @endcode
 */
+ (UIPageViewController* (^)(UIPageViewControllerTransitionStyle style,UIPageViewControllerNavigationOrientation navigationOrientation,NSDictionary<NSString *, id> * options))sk_init;

/**
 Set delegate.
 @code
 self.sk_delegate(delegate);
 @endcode
 */
- (UIPageViewController* (^)(id<UIPageViewControllerDelegate> delegate))sk_delegate;

/**
 Set dataSource.
 @code
 self.sk_dataSource(dataSource);
 @endcode
 */
- (UIPageViewController* (^)(id<UIPageViewControllerDataSource> dataSource))sk_dataSource;

/**
 Set doubleSided.
 @code
 self.sk_doubleSided(doubleSided);
 @endcode
 */
- (UIPageViewController* (^)(BOOL doubleSided))sk_doubleSided;

/**
 Set viewControllers.
 @code
 self.sk_setViewControllers(viewControllers,direction,animated,^(BOOL finished){
    your code;
 });
 @endcode
 */
- (UIPageViewController* (^)(NSArray<UIViewController *> * viewControllers,UIPageViewControllerNavigationDirection direction,BOOL animated,void(^completion)(BOOL finished)))sk_setViewControllers;

@end

