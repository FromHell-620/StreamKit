//
//  TKPageControl.h
//  ToolKit
//
//  Created by chunhui on 15/11/25.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKPageControl : UIPageControl

@property(nonatomic , strong) UIImage *pageIndicatorImage;
@property(nonatomic , strong) UIImage *currentPageIndicatorImage;
@property(nonatomic , assign) CGSize indicatorSize;
@property(nonatomic , assign) BOOL circleDot;//page control的点是否是圆点

@end
