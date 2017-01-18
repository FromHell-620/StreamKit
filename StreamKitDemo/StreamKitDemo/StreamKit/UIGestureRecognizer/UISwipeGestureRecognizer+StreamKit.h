//
//  UISwipeGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
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

/**
 Initializes an allocated swipeGesture-recognizer object.
 @code
 UISwipeGestureRecognizer* recognizer = UISwipeGestureRecognizer.sk_initWithBlock(^(UISwipeGestureRecognizer* recognizer){
    your code;
 });
 @endcode
 @return a block which receive an event block.
 */
+ (UISwipeGestureRecognizer* (^)(void(^block)(UISwipeGestureRecognizer* recognizer)))sk_initWithBlock;

/**
 Set numberOfTouchesRequired.
 @code
 self.sk_numberOfTouchesRequired(numberOfTouchesRequired);
 @endcode
 */
- (UISwipeGestureRecognizer* (^)(NSUInteger numberOfTouchesRequired))sk_numberOfTouchesRequired;

/**
 Set direction.
 @code
 self.sk_direction(direction);
 @endcode
 */
- (UISwipeGestureRecognizer* (^)(UISwipeGestureRecognizerDirection direction))sk_direction;

@end
