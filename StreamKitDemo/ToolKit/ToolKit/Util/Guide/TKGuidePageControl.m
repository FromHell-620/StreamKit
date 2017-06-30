//
//  TKGuidePageControl.m
//  Find
//
//  Created by chunhui on 15/9/17.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "TKGuidePageControl.h"
#import "UIView+Utils.h"

#define kTag 1000

@interface TKGuidePageControl ()

@property(nonatomic , strong) NSMutableArray *dots;

@end

@implementation TKGuidePageControl


-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    if (numberOfPages < 0) {
        return;
    }
    
    _numberOfPages = numberOfPages;
    
    [self.dots enumerateObjectsUsingBlock:^(UIImageView*   obj, NSUInteger idx, BOOL *  stop) {
        [obj removeFromSuperview];
    }];
    [self.dots removeAllObjects];
    
    
    UIImageView *imageView = nil;
    UIImage *image = [UIImage imageNamed:@"guide_circle"];
    UIImage *highImage = [UIImage imageNamed:@"guide_dot"];
    for (int i = 0 ; i < numberOfPages; i++) {
        imageView = [[UIImageView alloc]initWithImage:image highlightedImage:highImage];
        imageView.tag = kTag + i;
        [_dots addObject:imageView];
        [self addSubview:imageView];
    }
    [self setNeedsLayout];
    
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage < 0 || currentPage > _dots.count) {
        return;
    }
    _currentPage = currentPage;
    UIImageView *imageView;
    for (int i = 0 ; i < [_dots count]; i++) {
        imageView = _dots[i];
        imageView.highlighted = i == currentPage;
    }
    
}

-(NSMutableArray *)dots
{
    if (_dots == nil) {
        _dots = [NSMutableArray new];
    }
    return _dots;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([_dots count] == 0) {
        return;
    }
    UIImageView *imageView = [_dots firstObject];
    CGFloat gap = 0;
    if ([_dots count] > 1) {
        gap = (self.width - imageView.width)/([_dots count]-1);
    }
    for (int i = 0 ; i < [_dots count] ; i++) {
        imageView = [_dots objectAtIndex:i];
        imageView.center = CGPointMake(imageView.width/2+i*gap, self.height/2);
    }
        
}


@end
