//
//  UIRotationGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRotationGestureRecognizer (StreamSuper)

- (UIRotationGestureRecognizer* (^)(void(^block)(UIRotationGestureRecognizer* recognizer)))sk_addTargetBlock;

- (UIRotationGestureRecognizer* (^)())sk_removeTargetBlock;

- (UIRotationGestureRecognizer* (^)())sk_clearTargetBlock;

- (UIRotationGestureRecognizer* (^)(id<UIGestureRecognizerDelegate> delegate))sk_delegate;

- (UIRotationGestureRecognizer* (^)(BOOL enabled))sk_enabled;

- (UIRotationGestureRecognizer* (^)(BOOL cancelsTouchesInView))sk_cancelsTouchesInView;

- (UIRotationGestureRecognizer* (^)(BOOL delaysTouchesBegan))sk_delaysTouchesBegan;

- (UIRotationGestureRecognizer* (^)(BOOL delaysTouchesEnded))sk_delaysTouchesEnded;

- (UIRotationGestureRecognizer* (^)(NSArray<NSNumber*>* allowedTouchTypes))sk_allowedTouchTypes;

- (UIRotationGestureRecognizer* (^)(NSArray<NSNumber*>* allowedPressTypes))sk_allowedPressTypes;

@end

@interface UIRotationGestureRecognizer (StreamKit)

+ (UIRotationGestureRecognizer* (^)(void(^block)(UIRotationGestureRecognizer* recognizer)))sk_initWithBlock;

- (UIRotationGestureRecognizer* (^)(CGFloat rotation))sk_rotation;

@end
