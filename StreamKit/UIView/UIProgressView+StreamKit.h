//
//  UIProgressView+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIProgressView (StreamKit)

+ (UIProgressView* (^)(CGRect frame))sk_initWithFrame;

+ (UIProgressView* (^)(UIProgressViewStyle style))sk_initWithProgressViewStyle;

- (UIProgressView* (^)(UIProgressViewStyle style))sk_progressViewStyle;

- (UIProgressView* (^)(float progress))sk_progress;

- (UIProgressView* (^)(UIColor* progressTintColor))sk_progressTintColor;

- (UIProgressView* (^)(UIColor* trackTintColor))sk_trackTintColor;

- (UIProgressView* (^)(UIImage* progressImage))sk_progressImage;

- (UIProgressView* (^)(UIImage* trackImage))sk_trackImage;

- (UIProgressView* (^)(float progress,BOOL animaled))sk_setProgress;

- (UIProgressView* (^)(NSProgress* progress))sk_observedProgress NS_AVAILABLE_IOS(9_0);

@end
