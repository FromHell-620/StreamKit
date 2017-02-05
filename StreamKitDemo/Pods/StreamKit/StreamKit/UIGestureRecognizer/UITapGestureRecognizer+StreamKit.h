//
//  UITapGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Overrides the super's methods.
 */
@interface UITapGestureRecognizer (StreamSuper)

- (UITapGestureRecognizer* (^)(void(^block)(UITapGestureRecognizer* recognizer)))sk_addTargetBlock;

- (UITapGestureRecognizer* (^)())sk_removeTargetBlock;

- (UITapGestureRecognizer* (^)(id<UIGestureRecognizerDelegate> delegate))sk_delegate;

- (UITapGestureRecognizer* (^)(BOOL enabled))sk_enabled;

- (UITapGestureRecognizer* (^)(BOOL cancelsTouchesInView))sk_cancelsTouchesInView;

- (UITapGestureRecognizer* (^)(BOOL delaysTouchesBegan))sk_delaysTouchesBegan;

- (UITapGestureRecognizer* (^)(BOOL delaysTouchesEnded))sk_delaysTouchesEnded;

- (UITapGestureRecognizer* (^)(NSArray<NSNumber*>* allowedTouchTypes))sk_allowedTouchTypes;

- (UITapGestureRecognizer* (^)(NSArray<NSNumber*>* allowedPressTypes))sk_allowedPressTypes;

@end

@interface UITapGestureRecognizer (StreamKit)

/**
 Initializes an allocated tapGesture-recognizer object.
 @code
 UITapGestureRecognizer* recognizer = UITapGestureRecognizer.sk_initWithBlock(^(UITapGestureRecognizer* recognizer){
    your code;
 });
 @endcode
 @return a block which receive an event block.
 */
+ (UITapGestureRecognizer* (^)(void(^block)(UITapGestureRecognizer* recognizer)))sk_initWithBlock;

/**
 Set numberOfTapsRequired.
 @code
 self.sk_numberOfTapsRequired(numberOfTapsRequired);
 @endcode
 */
- (UITapGestureRecognizer* (^)(NSUInteger numberOfTapsRequired))sk_numberOfTapsRequired;

/**
 Set numberOfTouchesRequired.
 @code
 self.sk_numberOfTouchesRequired(numberOfTouchesRequired);
 @endcode
 */
- (UITapGestureRecognizer* (^)(NSUInteger numberOfTouchesRequired))sk_numberOfTouchesRequired;

@end
