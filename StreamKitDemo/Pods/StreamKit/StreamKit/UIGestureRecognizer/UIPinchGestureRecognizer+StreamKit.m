//
//  UIPinchGestureRecognizer+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIPinchGestureRecognizer+StreamKit.h"

@implementation UIPinchGestureRecognizer (StreamKit)

+ (UIPinchGestureRecognizer* (^)(void(^block)(UIPinchGestureRecognizer* recognizer)))sk_initWithBlock
{
    return ^ UIPinchGestureRecognizer* (void(^block)(UIPinchGestureRecognizer* recognizer)) {
        return UIPinchGestureRecognizer.new.sk_addTargetBlock(block);
    };
}

- (UIPinchGestureRecognizer* (^)(CGFloat scale))sk_scale
{
    return ^ UIPinchGestureRecognizer* (CGFloat scale) {
        return ({self.scale = scale;self;});
    };
}

@end
