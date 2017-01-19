//
//  UIProgressView+StreamKit.h
//  StreamKit
//
//  Created by 李浩 on 2016/12/18.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIProgressView (StreamKit)

/**
 Creates a new progressView by the given frame.
 @code
 UIProgressView* progressView = UIProgressView.sk_initWithFrame(frame);
 @endcode
 */
+ (UIProgressView* (^)(CGRect frame))sk_initWithFrame;

/**
 Creates a new progressView by the given progressViewStyle.
 @code
 UIProgressView* progressView = UIProgressView.sk_initWithProgressViewStyle(style);
 @endcode
 */
+ (UIProgressView* (^)(UIProgressViewStyle style))sk_initWithProgressViewStyle;

/**
 Set progressViewStyle.
 @code
 self.sk_progressViewStyle(style);
 @endcode
 */
- (UIProgressView* (^)(UIProgressViewStyle style))sk_progressViewStyle;

/**
 Set progress.
 @code
 self.sk_progress(progress);
 @endcode
 */
- (UIProgressView* (^)(float progress))sk_progress;

/**
 Set progressTintColor.
 @code
 self.sk_progressTintColor(progressTintColor);
 @endcode
 */
- (UIProgressView* (^)(UIColor* progressTintColor))sk_progressTintColor;

/**
 Set trackTintColor.
 @code
 self.sk_trackTintColor(trackTintColor);
 @endcode
 */
- (UIProgressView* (^)(UIColor* trackTintColor))sk_trackTintColor;

/**
 Set progressImage.
 @code
 self.sk_progressImage(progressImage);
 @endcode
 */
- (UIProgressView* (^)(UIImage* progressImage))sk_progressImage;

/**
 Set trackImage.
 @code
 self.sk_trackImage(trackImage);
 @endcode
 */
- (UIProgressView* (^)(UIImage* trackImage))sk_trackImage;

/**
 Set progress.
 @code
 self.sk_progressWithAnimaled(progress,animaled);
 @endcode
 */
- (UIProgressView* (^)(float progress,BOOL animaled))sk_progressWithAnimaled;

/**
 Set observedProgress.
 @code
 self.sk_observedProgress(observedProgress);
 @endcode
 */
- (UIProgressView* (^)(NSProgress* progress))sk_observedProgress NS_AVAILABLE_IOS(9_0);

@end
