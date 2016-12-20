//
//  UITapGestureRecognizer+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UITapGestureRecognizer+StreamKit.h"

@implementation UITapGestureRecognizer (StreamKit)

+ (UITapGestureRecognizer* (^)(void(^block)(UITapGestureRecognizer* recognizer)))sk_initWithBlock
{
    return ^ UITapGestureRecognizer* (void(^block)(UITapGestureRecognizer* recognizer)) {
        return UITapGestureRecognizer.new.sk_addTargetBlock(block);
    };
}

- (UITapGestureRecognizer* (^)(NSUInteger numberOfTapsRequired))sk_numberOfTapsRequired
{
    return ^ UITapGestureRecognizer* (NSUInteger numberOfTapsRequired) {
        return ({self.numberOfTapsRequired = numberOfTapsRequired;self;});
    };
}

- (UITapGestureRecognizer* (^)(NSUInteger numberOfTouchesRequired))sk_numberOfTouchesRequired
{
    return ^ UITapGestureRecognizer* (NSUInteger numberOfTouchesRequired) {
        return ({self.numberOfTouchesRequired = numberOfTouchesRequired;self;});
    };
}

@end
