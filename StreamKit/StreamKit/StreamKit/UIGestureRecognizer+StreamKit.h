//
//  UIGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/19.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (StreamKit)

+ (UIGestureRecognizer* (^)(void(^block)(UIGestureRecognizer* recognizer)))sk_initWithBlock;

- (UIGestureRecognizer* (^)(void(^block)(UIGestureRecognizer* recognizer)))sk_addTargetBlock;

- (UIGestureRecognizer* (^)())sk_removeTargetBlock;

- (UIGestureRecognizer* (^)())sk_clearTargetBlock;

- (UIGestureRecognizer* (^)(id<UIGestureRecognizerDelegate> delegate))sk_delegate;

- (UIGestureRecognizer* (^)(BOOL enabled))sk_enabled;

- (UIGestureRecognizer* (^)(BOOL cancelsTouchesInView))sk_cancelsTouchesInView;

- (UIGestureRecognizer* (^)(BOOL delaysTouchesBegan))sk_delaysTouchesBegan;

- (UIGestureRecognizer* (^)(BOOL delaysTouchesEnded))sk_delaysTouchesEnded;

- (UIGestureRecognizer* (^)(NSArray<NSNumber*>* allowedTouchTypes))sk_allowedTouchTypes;

- (UIGestureRecognizer* (^)(NSArray<NSNumber*>* allowedPressTypes))sk_allowedPressTypes;

@end

@interface UIGestureRecognizer (StreamDelegate)

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer)))sk_gestureShouldBegin;

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldRecognizeSimultaneously;

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldRequireFailure;

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldBeRequiredToFail;

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UITouch* touch)))sk_gestureShouldReceiveTouch;

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIPress* press)))sk_gestureshouldReceivePress;

@end
