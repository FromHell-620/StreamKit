//
//  TKSwitchSlideView.h
//  ToolKit
//
//  Created by chunhui on 16/3/31.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKSwitchSlideView : UIView

@property(nonatomic , copy) void(^chooseItem)(NSInteger index);

/**
 *  滑动标题栏背景颜色
 */
@property(nonatomic , strong)UIColor *slideBackgroundColor;

@property(nonatomic)UIEdgeInsets slideEdgeInsets;

@property(nonatomic,assign) BOOL isAllowGradualChange;//是否允许渐变


-(instancetype)initWithFrame:(CGRect)frame  NS_UNAVAILABLE ;

-(instancetype)initWithFrame:(CGRect)frame cellClass:(Class) cellClass;

-(instancetype)initWithFrame:(CGRect)frame cellClass:(Class) cellClass edgeInsets:(UIEdgeInsets)edgeInsets;

-(void)updateWithItems:(NSArray<NSString *> *)itemTitles;
/**
 *  设置默认选中项
 *
 *  @param index 选中项的序号
 */
-(void)selectAtIndex:(NSInteger)index;

-(void)adjustCellAtIndex:(NSInteger)index offset:(CGFloat)offset;

-(NSInteger)currentSelectIndex;

@end

