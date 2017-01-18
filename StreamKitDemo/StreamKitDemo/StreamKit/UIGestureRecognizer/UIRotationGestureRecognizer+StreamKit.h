//
//  UIRotationGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
@interface UIRotationGestureRecognizer (StreamSuper)

- (UIRotationGestureRecognizer* (^)(void(^block)(UIRotationGestureRecognizer* recognizer)))sk_addTargetBlock;

- (UIRotationGestureRecognizer* (^)())sk_removeTargetBlock;

- (UIRotationGestureRecognizer* (^)(id<UIGestureRecognizerDelegate> delegate))sk_delegate;

- (UIRotationGestureRecognizer* (^)(BOOL enabled))sk_enabled;

- (UIRotationGestureRecognizer* (^)(BOOL cancelsTouchesInView))sk_cancelsTouchesInView;

- (UIRotationGestureRecognizer* (^)(BOOL delaysTouchesBegan))sk_delaysTouchesBegan;

- (UIRotationGestureRecognizer* (^)(BOOL delaysTouchesEnded))sk_delaysTouchesEnded;

- (UIRotationGestureRecognizer* (^)(NSArray<NSNumber*>* allowedTouchTypes))sk_allowedTouchTypes;

- (UIRotationGestureRecognizer* (^)(NSArray<NSNumber*>* allowedPressTypes))sk_allowedPressTypes;

@end

@interface UIRotationGestureRecognizer (StreamKit)

/**
 Initializes an allocated rotationGesture-recognizer object.
 @code
 UIRotationGestureRecognizer* recognizer = UIRotationGestureRecognizer.sk_initWithBlock(^(UIRotationGestureRecognizer* recognizer){
    your code;
 });
 @endcode
 @return a block which receive an event block.
 */
+ (UIRotationGestureRecognizer* (^)(void(^block)(UIRotationGestureRecognizer* recognizer)))sk_initWithBlock;

/**
 Set rotation
 @code
 self.sk_rotation(rotation);
 @endcode
 */
- (UIRotationGestureRecognizer* (^)(CGFloat rotation))sk_rotation;

@end
