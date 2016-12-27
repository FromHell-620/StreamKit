//
//  UITapGestureRecognizer+StreamKit.h
//  StreamKit
//
//  Created by 苏南 on 16/12/20.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <UIKit/UIKit.h>

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

+ (UITapGestureRecognizer* (^)(void(^block)(UITapGestureRecognizer* recognizer)))sk_initWithBlock;

- (UITapGestureRecognizer* (^)(NSUInteger numberOfTapsRequired))sk_numberOfTapsRequired;

- (UITapGestureRecognizer* (^)(NSUInteger numberOfTouchesRequired))sk_numberOfTouchesRequired;

@end
