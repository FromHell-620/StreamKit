//
//  UILongPressGestureRecognizer+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UILongPressGestureRecognizer+StreamKit.h"

@implementation UILongPressGestureRecognizer (StreamKit)

+ (UILongPressGestureRecognizer* (^)(void(^block)(UILongPressGestureRecognizer* recognizer)))sk_initWithBlock
{
    return ^ UILongPressGestureRecognizer* (void(^block)(UILongPressGestureRecognizer* recognizer)) {
        return UILongPressGestureRecognizer.new.sk_addTargetBlock(block);
    };
}

- (UILongPressGestureRecognizer* (^)(NSUInteger numberOfTapsRequired))sk_numberOfTapsRequired
{
    return ^ UILongPressGestureRecognizer* (NSUInteger numberOfTapsRequired) {
        return ({self.numberOfTapsRequired = numberOfTapsRequired;self;});
    };
}

- (UILongPressGestureRecognizer* (^)(NSUInteger numberOfTouchesRequired))sk_numberOfTouchesRequired
{
    return ^ UILongPressGestureRecognizer* (NSUInteger numberOfTouchesRequired) {
        return ({self.numberOfTapsRequired = numberOfTouchesRequired;self;});
    };
}

- (UILongPressGestureRecognizer* (^)(CFTimeInterval minimumPressDuration))sk_minimumPressDuration
{
    return ^ UILongPressGestureRecognizer* (CFTimeInterval minimumPressDuration) {
        return ({self.minimumPressDuration = minimumPressDuration;self;});
    };
}

- (UILongPressGestureRecognizer* (^)(CGFloat allowableMovement))sk_allowableMovement
{
    return ^ UILongPressGestureRecognizer* (CGFloat allowableMovement) {
        return ({self.allowableMovement = allowableMovement;self;});
    };
}

@end
