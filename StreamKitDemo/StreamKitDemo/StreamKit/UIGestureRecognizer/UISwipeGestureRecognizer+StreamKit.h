//
//  UISwipeGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwipeGestureRecognizer (StreamSuper)

- (UISwipeGestureRecognizer* (^)(void(^block)(UISwipeGestureRecognizer* recognizer)))sk_addTargetBlock;

- (UISwipeGestureRecognizer* (^)())sk_removeTargetBlock;

- (UISwipeGestureRecognizer* (^)(id<UIGestureRecognizerDelegate> delegate))sk_delegate;

- (UISwipeGestureRecognizer* (^)(BOOL enabled))sk_enabled;

- (UISwipeGestureRecognizer* (^)(BOOL cancelsTouchesInView))sk_cancelsTouchesInView;

- (UISwipeGestureRecognizer* (^)(BOOL delaysTouchesBegan))sk_delaysTouchesBegan;

- (UISwipeGestureRecognizer* (^)(BOOL delaysTouchesEnded))sk_delaysTouchesEnded;

- (UISwipeGestureRecognizer* (^)(NSArray<NSNumber*>* allowedTouchTypes))sk_allowedTouchTypes;

- (UISwipeGestureRecognizer* (^)(NSArray<NSNumber*>* allowedPressTypes))sk_allowedPressTypes;

@end

@interface UISwipeGestureRecognizer (StreamKit)

+ (UISwipeGestureRecognizer* (^)(void(^block)(UISwipeGestureRecognizer* recognizer)))sk_initWithBlock;

- (UISwipeGestureRecognizer* (^)(NSUInteger numberOfTouchesRequired))sk_numberOfTouchesRequired;

- (UISwipeGestureRecognizer* (^)(UISwipeGestureRecognizerDirection direction))sk_direction;

@end
