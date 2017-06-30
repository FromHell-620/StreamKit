//
//  TKViewController.h
//  ToolKit
//
//  Created by chunhui on 15/6/28.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKViewController : UIViewController

+(TKViewController *)instance;

/**
 是否应该显示statusbar, 默认显示.
 每个页面定制statusBar需要在plist内的view controller-based status bar appearance是YES, 默认是YES
 **/
@property (nonatomic, assign) BOOL shouldShowStatusBar;
/// status bar的风格, 可以修改
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

// Init In ViewDidLoad
- (void)initData;
- (void)initView;

// Notifications
- (void)addNotifications;

@end
