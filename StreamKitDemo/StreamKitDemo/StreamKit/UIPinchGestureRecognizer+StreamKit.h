//
//  UIPinchGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPinchGestureRecognizer (StreamSuper)

- (UIPinchGestureRecognizer* (^)(void(^block)(UIPinchGestureRecognizer* recognizer)))sk_addTargetBlock;

- (UIPinchGestureRecognizer* (^)())sk_removeTargetBlock;

- (UIPinchGestureRecognizer* (^)(id<UIGestureRecognizerDelegate> delegate))sk_delegate;

- (UIPinchGestureRecognizer* (^)(BOOL enabled))sk_enabled;

- (UIPinchGestureRecognizer* (^)(BOOL cancelsTouchesInView))sk_cancelsTouchesInView;

- (UIPinchGestureRecognizer* (^)(BOOL delaysTouchesBegan))sk_delaysTouchesBegan;

- (UIPinchGestureRecognizer* (^)(BOOL delaysTouchesEnded))sk_delaysTouchesEnded;

- (UIPinchGestureRecognizer* (^)(NSArray<NSNumber*>* allowedTouchTypes))sk_allowedTouchTypes;

- (UIPinchGestureRecognizer* (^)(NSArray<NSNumber*>* allowedPressTypes))sk_allowedPressTypes;

@end

@interface UIPinchGestureRecognizer (StreamKit)

+ (UIPinchGestureRecognizer* (^)(void(^block)(UIPinchGestureRecognizer* recognizer)))sk_initWithBlock;

- (UIPinchGestureRecognizer* (^)(CGFloat scale))sk_scale;

@end
