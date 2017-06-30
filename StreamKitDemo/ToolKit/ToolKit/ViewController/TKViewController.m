//
//  TKViewController.m
//  ToolKit
//
//  Created by chunhui on 15/6/28.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import "TKViewController.h"
#import "TKDefines.h"

@interface TKViewController ()

@end

@implementation TKViewController

+(TKViewController *)instance
{
    TKViewController *controller = [[self alloc]init];
    return controller;
}


/**
 init后的再次初始化一些变量
 **/
- (void)extraInit
{
    self.shouldShowStatusBar = YES;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self addNotifications];
}

- (BOOL)prefersStatusBarHidden
{
    return !self.shouldShowStatusBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}

#pragma mark - LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self extraInit];
    }
    return self;
}

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        [self extraInit];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self extraInit];
    }
    return self;
}
- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self initView];
    
}

- (void)initData
{
    
}

- (void)initView
{
}

- (void)addNotifications
{
    
}


@end
