//
//  TKSwitchSlideItemCollectionViewCell.m
//  ToolKit
//
//  Created by chunhui on 16/3/31.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKSwitchSlideItemCollectionViewCell.h"
#import "NSString+TKSize.h"

@implementation TKSwitchSlideItemCollectionViewCell

+(CGFloat)cellWidthForTitle:(NSString *)title
{
    
    CGFloat width = 30;
    
    width += [title sizeWithMaxWidth:1000 font:[UIFont systemFontOfSize:15]].width;
    
    return width;
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        [self initTitleLabel];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self initTitleLabel];
    }
    return self;
}

-(void)initTitleLabel
{

    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = RGB(129, 179, 217);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_titleLabel];    
}

-(void)updateWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = self.bounds;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        _titleLabel.textColor = RGB(25, 125, 202);
    }else{
        _titleLabel.textColor = RGB(129, 179, 217);
    }
}

-(void)updateWithOffset:(CGFloat)offset
{
    _titleLabel.textColor = RGB(129 + (25 - 129) * offset, 179 + (125 - 179) * offset, 217 + (202 - 217) * offset);
}

@end
