//
//  TKSwitchSlideItemCollectionViewCell.h
//  ToolKit
//
//  Created by chunhui on 16/3/31.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKSwitchSlideItemCollectionViewCell : UICollectionViewCell

@property(nonatomic , strong) UILabel *titleLabel;

+(CGFloat)cellWidthForTitle:(NSString *)title;

-(void)updateWithTitle:(NSString *)title;

-(void)setSelected:(BOOL)selected;

//根据offset值调节中间状态 1全选中 0未选中
-(void)updateWithOffset:(CGFloat)offset;

@end
