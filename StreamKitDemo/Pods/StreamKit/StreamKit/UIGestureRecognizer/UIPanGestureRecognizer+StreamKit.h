//
//  UIPanGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

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

+ (UIPanGestureRecognizer* (^)(void(^block)(UIPanGestureRecognizer* recognizer)))sk_initWithBlock;

- (UIPanGestureRecognizer* (^)(NSUInteger minimumNumberOfTouches))sk_minimumNumberOfTouches;

-  (UIPanGestureRecognizer* (^)(NSUInteger maximumNumberOfTouches))sk_maximumNumberOfTouches;


@end
