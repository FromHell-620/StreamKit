//
//  TKGuidTransitionDelegate.m
//  MeiYuanBang
//
//  Created by chunhui on 15/6/6.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import "TKGuidTransitionDelegate.h"
#import "TKGuideTranistion.h"

@implementation TKGuidTransitionDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    TKGuideTranistion *transitioning = [TKGuideTranistion new];
    return transitioning;
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    TKGuideTranistion *transitioning = [TKGuideTranistion new];
    
    return transitioning;
}

@end
