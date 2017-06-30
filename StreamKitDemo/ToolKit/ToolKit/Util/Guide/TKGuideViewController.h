//
//  FDGuideViewController.h
//  MeiYuanBang
//
//  Created by chunhui on 15/6/3.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKGuideViewController : UIViewController

@property(nonatomic , assign) NSTimeInterval showDuration ;// 0 为等待用户手动删除

@property(nonatomic, strong) NSArray<UIImage *> *guideImages;
/**
 *  是否显示 page control 
 */
@property(nonatomic, assign) BOOL showPageControl;

@property(nonatomic , copy) void (^quitBlock)();

@property(nonatomic, assign)BOOL isHiddenTouchLast;//点击最后图片是否移除引导页


@property(nonatomic , assign) BOOL tapLastToQuit;


@end
