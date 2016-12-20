//
//  UILongPressGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILongPressGestureRecognizer (StreamSuper)

- (UILongPressGestureRecognizer* (^)(void(^block)(UILongPressGestureRecognizer* recognizer)))sk_addTargetBlock;

- (UILongPressGestureRecognizer* (^)())sk_removeTargetBlock;

- (UILongPressGestureRecognizer* (^)(id<UIGestureRecognizerDelegate> delegate))sk_delegate;

- (UILongPressGestureRecognizer* (^)(BOOL enabled))sk_enabled;

- (UILongPressGestureRecognizer* (^)(BOOL cancelsTouchesInView))sk_cancelsTouchesInView;

- (UILongPressGestureRecognizer* (^)(BOOL delaysTouchesBegan))sk_delaysTouchesBegan;

- (UILongPressGestureRecognizer* (^)(BOOL delaysTouchesEnded))sk_delaysTouchesEnded;

- (UILongPressGestureRecognizer* (^)(NSArray<NSNumber*>* allowedTouchTypes))sk_allowedTouchTypes;

- (UILongPressGestureRecognizer* (^)(NSArray<NSNumber*>* allowedPressTypes))sk_allowedPressTypes;

@end

@interface UILongPressGestureRecognizer (StreamKit)

+ (UILongPressGestureRecognizer* (^)(void(^block)(UILongPressGestureRecognizer* recognizer)))sk_initWithBlock;

- (UILongPressGestureRecognizer* (^)(NSUInteger numberOfTapsRequired))sk_numberOfTapsRequired;

- (UILongPressGestureRecognizer* (^)(NSUInteger numberOfTouchesRequired))sk_numberOfTouchesRequired;

- (UILongPressGestureRecognizer* (^)(CFTimeInterval minimumPressDuration))sk_minimumPressDuration;

- (UILongPressGestureRecognizer* (^)(CGFloat allowableMovement))sk_allowableMovement;

@end
