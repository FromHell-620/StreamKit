//
//  TKPageControl.m
//  ToolKit
//
//  Created by chunhui on 15/11/25.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "TKPageControl.h"

@implementation TKPageControl

-(void)updateIndicator
{
    if(!_circleDot){
        for (UIView *indicator in self.subviews) {
            indicator.layer.cornerRadius = 0;
            indicator.clipsToBounds = NO;
            indicator.layer.masksToBounds = NO;
        }
    }else if (_indicatorSize.width > 0 && _indicatorSize.height > 0){
        for (UIView *indicator in self.subviews) {
            indicator.bounds = CGRectMake(0, 0, _indicatorSize.width, _indicatorSize.height);
            indicator.layer.cornerRadius = _indicatorSize.width/2;
        }
    }
    
}

-(void)layoutSubviews
{
    [self updateIndicator];
    [super layoutSubviews];
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateIndicator];
}

-(void)setIndicatorSize:(CGSize)indicatorSize
{
    _indicatorSize = indicatorSize;
    [self updateCurrentPageDisplay];
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    return _indicatorSize;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
