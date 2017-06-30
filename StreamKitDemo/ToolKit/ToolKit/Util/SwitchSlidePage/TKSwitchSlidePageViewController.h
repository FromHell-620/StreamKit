//
//  TKSwitchSlidePageViewController.h
//  ToolKit
//
//  Created by chunhui on 16/3/31.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKViewController.h"
#import "TKSwitchSlidePageItemViewControllerProtocol.h"

@class TKSwithSlideItemViewController;
@protocol TKSwitchSlidePageViewControllerDelegate;

@interface TKSwitchSlidePageViewController : TKViewController

@property(nonatomic , assign) CGFloat slideSwitchHeight;
@property(nonatomic) UIEdgeInsets slideEdgeInsets;
@property(nonatomic , strong) Class slideItemClass;
@property(nonatomic , weak) id<TKSwitchSlidePageViewControllerDelegate> delegate;
@property(nonatomic,assign) BOOL isAllowGradualChange;//是否允许渐变

/**
 *  滑动标题栏背景颜色
 */
@property(nonatomic , strong)UIColor *slideBackgroundColor;

/**
 *  设置选中项
 *
 *  @param index 选中index
 */
-(void)selectedAtIndex:(NSInteger)index;

-(NSInteger)currentIndex;

- (void)reload;

- (void)updateSlideViewFrame:(CGFloat)topOffset;

- (void)updateCollectionViewFrame:(CGFloat)disToBottom;

- (UIViewController<TKSwitchSlidePageItemViewControllerProtocol> *)currentShowController;

@end


@protocol TKSwitchSlidePageViewControllerDelegate <NSObject>

@required
-(NSInteger)numberofPages;
-(UIViewController<TKSwitchSlidePageItemViewControllerProtocol> *)controllerForIndex:(NSInteger)index;
-(NSArray *)pageTitles;
-(void)willReuseController:(UIViewController<TKSwitchSlidePageItemViewControllerProtocol> *) controller forIndex:(NSInteger)index;
/**
 *  点击当前项
 *
 *  @param index
 */
-(void)tapCurrentItem:(NSInteger)index controller:(UIViewController<TKSwitchSlidePageItemViewControllerProtocol> *)controller;

@end

