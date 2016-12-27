//
//  UIImageView+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIImageView+StreamKit.h"

@implementation UIImageView (StreamKit)

+ (UIImageView* (^)(CGRect frame))sk_initWithFrame
{
    return ^ UIImageView* (CGRect frame) {
        return [[UIImageView alloc] initWithFrame:frame];
    };
}

+ (UIImageView* (^)(UIImage* image))sk_initWithImage
{
    return ^ UIImageView* (UIImage* image) {
        return [[UIImageView alloc] initWithImage:image];
    };
}

- (UIImageView* (^)(UIImage* image))sk_image
{
    return ^ UIImageView* (UIImage* image) {
        return ({self.image = image;self;});
    };
}

- (UIImageView* (^)(UIImage* highlightedImage))sk_highlightedImage
{
    return ^ UIImageView* (UIImage* highlightedImage) {
        return ({self.highlightedImage = highlightedImage;self;});
    };
}

- (UIImageView* (^)(BOOL highlighted))sk_highlighted
{
    return ^ UIImageView* (BOOL highlighted) {
        return ({self.highlighted = highlighted;self;});
    };
}

- (UIImageView* (^)(NSArray<UIImage*>* animationImages))sk_animationImages
{
    return ^ UIImageView* (NSArray<UIImage*>* animationImages) {
        return ({self.animationImages = animationImages;self;});
    };
}

- (UIImageView* (^)(NSArray<UIImage*>* highlightedAnimationImages))sk_highlightedAnimationImages
{
    return ^ UIImageView* (NSArray<UIImage*>* highlightedAnimationImages) {
        return ({self.highlightedAnimationImages = highlightedAnimationImages;self;});
    };
}

- (UIImageView* (^)(NSTimeInterval animationDuration))sk_animationDuration
{
    return ^ UIImageView* (NSTimeInterval animationDuration) {
        return ({self.animationDuration = animationDuration;self;});
    };
}

- (UIImageView* (^)(NSInteger animationRepeatCount))sk_animationRepeatCount
{
    return ^ UIImageView* (NSInteger animationRepeatCount) {
        return ({self.animationRepeatCount = animationRepeatCount;self;});
    };
}

@end
