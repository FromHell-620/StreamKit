//
//  UIPanGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
@interface UIPanGestureRecognizer (StreamSuper)

- (UIPanGestureRecognizer* (^)(void(^block)(UIPanGestureRecognizer* recognizer)))sk_addTargetBlock;

- (UIPanGestureRecognizer* (^)())sk_removeTargetBlock;

- (UIPanGestureRecognizer* (^)(id<UIGestureRecognizerDelegate> delegate))sk_delegate;

- (UIPanGestureRecognizer* (^)(BOOL enabled))sk_enabled;

- (UIPanGestureRecognizer* (^)(BOOL cancelsTouchesInView))sk_cancelsTouchesInView;

- (UIPanGestureRecognizer* (^)(BOOL delaysTouchesBegan))sk_delaysTouchesBegan;

- (UIPanGestureRecognizer* (^)(BOOL delaysTouchesEnded))sk_delaysTouchesEnded;

- (UIPanGestureRecognizer* (^)(NSArray<NSNumber*>* allowedTouchTypes))sk_allowedTouchTypes;

- (UIPanGestureRecognizer* (^)(NSArray<NSNumber*>* allowedPressTypes))sk_allowedPressTypes;

@end

@interface UIPanGestureRecognizer (StreamKit)

/**
 Initializes an allocated panGesture-recognizer object.
 @code
 UIPanGestureRecognizer* recognizer = UIPanGestureRecognizer.sk_initWithBlock(^(UIPanGestureRecognizer* recognizer){
    your code;
 });
 @endcode
 @return a block which receive an event block.
 */
+ (UIPanGestureRecognizer* (^)(void(^block)(UIPanGestureRecognizer* recognizer)))sk_initWithBlock;

/**
 Set minimumNumberOfTouches.
 @code
 self.sk_minimumNumberOfTouches(minimumNumberOfTouches);
 @endcode
 */
- (UIPanGestureRecognizer* (^)(NSUInteger minimumNumberOfTouches))sk_minimumNumberOfTouches;

/**
 Set maximumNumberOfTouches.
 @code 
 self.sk_maximumNumberOfTouches(maximumNumberOfTouches);
 @endcode
 */
-  (UIPanGestureRecognizer* (^)(NSUInteger maximumNumberOfTouches))sk_maximumNumberOfTouches;

@end
