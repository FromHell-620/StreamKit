//
//  UIRotationGestureRecognizer+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIRotationGestureRecognizer+StreamKit.h"

@implementation UIRotationGestureRecognizer (StreamKit)

+ (UIRotationGestureRecognizer* (^)(void(^block)(UIRotationGestureRecognizer* recognizer)))sk_initWithBlock
{
    return ^ UIRotationGestureRecognizer* (void(^block)(UIRotationGestureRecognizer* recognizer)) {
        return UIRotationGestureRecognizer.new.sk_addTargetBlock(block);
    };
}

- (UIRotationGestureRecognizer* (^)(CGFloat rotation))sk_rotation
{
    return ^ UIRotationGestureRecognizer* (CGFloat rotation) {
        return ({self.rotation = rotation;self;});
    };
}

@end
