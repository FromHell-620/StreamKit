//
//  UILongPressGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
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

/**
 Initializes an allocated longPressGesture-recognizer object.
 @code
 UILongPressGestureRecognizer* recognizer = UILongPressGestureRecognizer.sk_initWithBlock(^(UILongPressGestureRecognizer* recognizer){
    your code;
 });
 @endcode
 @return a block which receive an event block.
 */
+ (UILongPressGestureRecognizer* (^)(void(^block)(UILongPressGestureRecognizer* recognizer)))sk_initWithBlock;

/**
 Set numberOfTapsRequired.
 @code
 self.sk_numberOfTapsRequired(numberOfTapsRequired);
 @endcode
 */
- (UILongPressGestureRecognizer* (^)(NSUInteger numberOfTapsRequired))sk_numberOfTapsRequired;

/**
 Set numberOfTouchesRequired
 @code
 self.sk_numberOfTouchesRequired(numberOfTouchesRequired);
 @endcode
 */
- (UILongPressGestureRecognizer* (^)(NSUInteger numberOfTouchesRequired))sk_numberOfTouchesRequired;

/**
 Set minimumPressDuration
 @code 
 self.sk_minimumPressDuration(minimumPressDuration);
 @endcode
 */
- (UILongPressGestureRecognizer* (^)(CFTimeInterval minimumPressDuration))sk_minimumPressDuration;

/**
 Set allowableMovement
 @code
 self.sk_allowableMovement(allowableMovement);
 @endcode
 */
- (UILongPressGestureRecognizer* (^)(CGFloat allowableMovement))sk_allowableMovement;

@end
