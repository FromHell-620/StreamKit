//
//  UIProgressView+StreamKit.m
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIProgressView+StreamKit.h"

@implementation UIProgressView (StreamKit)

+ (UIProgressView* (^)(CGRect frame))sk_initWithFrame
{
    return ^ UIProgressView* (CGRect frame) {
        return [[UIProgressView alloc] initWithFrame:frame];
    };
}

+ (UIProgressView* (^)(UIProgressViewStyle style))sk_initWithProgressViewStyle
{
    return ^ UIProgressView* (UIProgressViewStyle style) {
        return [[UIProgressView alloc] initWithProgressViewStyle:style];
    };
}

- (UIProgressView* (^)(UIProgressViewStyle style))sk_progressViewStyle
{
    return ^ UIProgressView* (UIProgressViewStyle style) {
        return ({self.progressViewStyle = style;self;});
    };
}

- (UIProgressView* (^)(float progress))sk_progress
{
    return ^ UIProgressView* (float progress) {
        return ({self.progress = progress;self;});
    };
}

- (UIProgressView* (^)(UIColor* progressTintColor))sk_progressTintColor
{
    return ^ UIProgressView* (UIColor* progressTintColor) {
        return ({self.progressTintColor = progressTintColor;self;});
    };
}

- (UIProgressView* (^)(UIColor* trackTintColor))sk_trackTintColor
{
    return ^ UIProgressView* (UIColor* trackTintColor) {
        return ({self.trackTintColor = trackTintColor;self;});
    };
}

- (UIProgressView* (^)(UIImage* progressImage))sk_progressImage
{
    return ^ UIProgressView* (UIImage* progressImage) {
        return ({self.progressImage = progressImage;self;});
    };
}

- (UIProgressView* (^)(UIImage* trackImage))sk_trackImage
{
    return ^ UIProgressView* (UIImage* trackImage) {
        return ({self.trackImage = trackImage;self;});
    };
}

- (UIProgressView* (^)(float progress,BOOL animaled))sk_progressWithAnimaled
{
    return ^ UIProgressView* (float progress,BOOL animaled) {
        return ({[self setProgress:progress animated:animaled];self;});
    };
}

- (UIProgressView* (^)(NSProgress* progress))sk_observedProgress
{
    return ^ UIProgressView* (NSProgress* progress) {
        return ({self.observedProgress = progress;self;});
    };
}

@end
