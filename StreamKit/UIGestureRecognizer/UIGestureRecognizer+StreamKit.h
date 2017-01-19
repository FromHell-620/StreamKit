//
//  UIGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/19.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (StreamKit)


/**
 Initializes an allocated gesture-recognizer object.
 @code
 UIGestureRecognizer* recognizer = UIGestureRecognizer.sk_initWithBlock(^(UIGestureRecognizer* recognizer){
    your code;
 });
 @endcode
 
 @return a block which receive a event block.
 */
+ (UIGestureRecognizer* (^)(void(^block)(UIGestureRecognizer* recognizer)))sk_initWithBlock;


/**
 Adds an event block to a gesture-recognizer object
 @code 
 self.sk_addTargetBlock(^(UIGestureRecognizer* recognizer){
    your code;
 });
 @endcode
 
 @return a block which receive a event block.
 */
- (UIGestureRecognizer* (^)(void(^block)(UIGestureRecognizer* recognizer)))sk_addTargetBlock;


/**
 Remove the event block.
 @code 
 self.sk_removeTargetBlock();
 @endcode
 
 @return a block you should invoke.
 */
- (UIGestureRecognizer* (^)())sk_removeTargetBlock;


/**
 Set delegate.
 @code 
 self.sk_delegate(delegate);
 @endcode
 */
- (UIGestureRecognizer* (^)(id<UIGestureRecognizerDelegate> delegate))sk_delegate;


/**
 Set enabled
 @code
 self.sk_enabled(enabled);
 @endcode
 */
- (UIGestureRecognizer* (^)(BOOL enabled))sk_enabled;

/**
 Set cancelsTouchesInView
 @code 
 self.sk_cancelsTouchesInView(cancelsTouchesInView);
 @endcode
 */
- (UIGestureRecognizer* (^)(BOOL cancelsTouchesInView))sk_cancelsTouchesInView;

/**
 Set delaysTouchesBegan
 @code
 self.sk_delaysTouchesBegan(delaysTouchesBegan);
 @endcode
 */
- (UIGestureRecognizer* (^)(BOOL delaysTouchesBegan))sk_delaysTouchesBegan;

/**
 Set delaysTouchesEnded
 @code
 self.sk_delaysTouchesEnded(delaysTouchesEnded);
 @endcode
 */
- (UIGestureRecognizer* (^)(BOOL delaysTouchesEnded))sk_delaysTouchesEnded;

/**
 Set allowedTouchTypes
 @code 
 self.sk_allowedTouchTypes(allowedTouchTypes);
 @endcode
 */
- (UIGestureRecognizer* (^)(NSArray<NSNumber*>* allowedTouchTypes))sk_allowedTouchTypes;

/**
 Set allowedPressTypes
 @code
 self.sk_allowedPressTypes(allowedPressTypes);
 @endcode
 */
- (UIGestureRecognizer* (^)(NSArray<NSNumber*>* allowedPressTypes))sk_allowedPressTypes;

@end

@interface UIGestureRecognizer (StreamDelegate)

/**
 Instead of the 'gestureRecognizerShouldBegin:'.
 @code 
 self.sk_gestureShouldBegin(^BOOL(UIGestureRecognizer* recognizer){
    your code;
 });
 @endcode
 @return a block which receive a event block and you should invoke.
         the event block will invoke when the delegate methods execute.
 */
- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer)))sk_gestureShouldBegin;

/**
 Instead of the 'gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:'.
 @code 
 self.sk_gestureShouldRecognizeSimultaneously(^BOOL(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer) {
    your code;
 });
 @endcode
 */
- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldRecognizeSimultaneously;

/**
 Instead of the 'gestureRecognizer:shouldRequireFailureOfGestureRecognizer:'.
 @code
 self.sk_gestureShouldRequireFailure(^BOOL(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer){
    your code;
 });
 @endcode
 */
- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldRequireFailure;

/**
 Instead of the 'gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:'.
 @code
 self.sk_gestureShouldBeRequiredToFail(^BOOL(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer){
    your code;
 });
 @endcode
 */
- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldBeRequiredToFail;

/**
 Instead of the 'gestureRecognizer:shouldReceiveTouch:'.
 @code
 self.sk_gestureShouldReceiveTouch(^BOOL(UIGestureRecognizer* recognizer,UITouch* touch){
    your code;
 });
 @endcode
 */
- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UITouch* touch)))sk_gestureShouldReceiveTouch;

/**
 Instead of the 'gestureRecognizer:shouldReceivePress:'.
 @code
 self.sk_gestureshouldReceivePress(^BOOL(UIGestureRecognizer* recognizer,UIPress* press){
    your code;
 });
 @endcode
 */
- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIPress* press)))sk_gestureshouldReceivePress;

@end
