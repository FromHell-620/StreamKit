//
//  UISwipeGestureRecognizer+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UISwipeGestureRecognizer+StreamKit.h"

@implementation UISwipeGestureRecognizer (StreamKit)

+ (UISwipeGestureRecognizer* (^)(void(^block)(UISwipeGestureRecognizer* recognizer)))sk_initWithBlock
{
    return ^ UISwipeGestureRecognizer* (void(^block)(UISwipeGestureRecognizer* recognizer)) {
        return UISwipeGestureRecognizer.new.sk_addTargetBlock(block);
    };
}

- (UISwipeGestureRecognizer* (^)(NSUInteger numberOfTouchesRequired))sk_numberOfTouchesRequired
{
    return ^ UISwipeGestureRecognizer* (NSUInteger numberOfTouchesRequired) {
        return ({self.numberOfTouchesRequired = numberOfTouchesRequired;self;});
    };
}

- (UISwipeGestureRecognizer* (^)(UISwipeGestureRecognizerDirection direction))sk_direction
{
    return ^ UISwipeGestureRecognizer* (UISwipeGestureRecognizerDirection direction) {
        return ({self.direction = direction;self;});
    };
}

@end
