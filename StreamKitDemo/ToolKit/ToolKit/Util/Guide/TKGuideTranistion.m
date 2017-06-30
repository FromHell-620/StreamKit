//
//  FDGuideTranistion.m
//  MeiYuanBang
//
//  Created by chunhui on 15/6/6.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import "TKGuideTranistion.h"

static NSTimeInterval const FDAnimatedTransitionDuration = 0.8f;

@implementation TKGuideTranistion

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    if (self.reverse) {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
    } else {
        CGRect frame = toViewController.view.frame;
        frame.origin.x = CGRectGetWidth(frame);
        toViewController.view.frame = frame;
        [container addSubview:toViewController.view];
    }
    
    [UIView animateKeyframesWithDuration:FDAnimatedTransitionDuration delay:0 options:0 animations:^{
        if (self.reverse) {
            CGRect frame = fromViewController.view.frame;
            frame.origin.x = CGRectGetWidth(frame);
            fromViewController.view.frame = frame;
        }else{
            CGRect frame = toViewController.view.frame;
            frame.origin.x = 0;
            toViewController.view.frame = frame;
            frame.origin.x = -CGRectGetWidth(frame);
            fromViewController.view.frame = frame;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
        
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return FDAnimatedTransitionDuration;
}


@end
