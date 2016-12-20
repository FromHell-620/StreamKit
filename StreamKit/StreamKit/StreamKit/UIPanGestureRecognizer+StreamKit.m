//
//  UIPanGestureRecognizer+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIPanGestureRecognizer+StreamKit.h"

@implementation UIPanGestureRecognizer (StreamKit)

+ (UIPanGestureRecognizer* (^)(void(^block)(UIPanGestureRecognizer* recognizer)))sk_initWithBlock
{
    return ^ UIPanGestureRecognizer* (void(^block)(UIPanGestureRecognizer* recognizer)) {
        return UIPanGestureRecognizer.new.sk_addTargetBlock(block);
    };
}

- (UIPanGestureRecognizer* (^)(NSUInteger minimumNumberOfTouches))sk_minimumNumberOfTouches
{
    return ^ UIPanGestureRecognizer* (NSUInteger minimumNumberOfToucher) {
        return ({self.minimumNumberOfTouches = minimumNumberOfToucher;self;});
    };
}

-  (UIPanGestureRecognizer* (^)(NSUInteger maximumNumberOfTouches))sk_maximumNumberOfTouches
{
    return ^ UIPanGestureRecognizer* (NSUInteger maximumNumberOfTouches) {
        return ({self.maximumNumberOfTouches = maximumNumberOfTouches;self;});
    };
}

@end
