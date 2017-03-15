//
//  UIGestureRecognizer+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/19.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIGestureRecognizer+StreamKit.h"
#import "NSObject+StreamKit.h"
@import ObjectiveC.runtime;
@import ObjectiveC.message;

@implementation UIGestureRecognizer (StreamKit)

+ (UIGestureRecognizer* (^)(void(^block)(UIGestureRecognizer* recognizer)))sk_initWithBlock
{
    return ^ UIGestureRecognizer* (void(^block)(UIGestureRecognizer* recognizer)) {
        return UIGestureRecognizer.new.sk_addTargetBlock(block);
    };
}

- (UIGestureRecognizer* (^)(void(^block)(UIGestureRecognizer* recognizer)))sk_addTargetBlock
{
    return ^ UIGestureRecognizer* (void(^block)(UIGestureRecognizer* recognizer)) {
        if (block) {
            objc_setAssociatedObject(self, (__bridge const void *)(self), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
            [self addTarget:self action:@selector(recognizerAction:)];
        }
        return self;
    };
}

- (UIGestureRecognizer* (^)())sk_removeTargetBlock
{
    return ^ UIGestureRecognizer* {
        objc_removeAssociatedObjects(self);
        return self;
    };
}

- (UIGestureRecognizer* (^)(id<UIGestureRecognizerDelegate> delegate))sk_delegate
{
    return ^ UIGestureRecognizer* (id<UIGestureRecognizerDelegate> delegate) {
        return ({self.delegate = delegate;self;});
    };
}

- (UIGestureRecognizer* (^)(BOOL enabled))sk_enabled
{
    return ^ UIGestureRecognizer* (BOOL enabled) {
        return ({self.enabled = enabled;self;});
    };
}

- (UIGestureRecognizer* (^)(BOOL cancelsTouchesInView))sk_cancelsTouchesInView
{
    return ^ UIGestureRecognizer* (BOOL cancelsTouchesInView) {
        return ({self.cancelsTouchesInView = cancelsTouchesInView;self;});
    };
}

- (UIGestureRecognizer* (^)(BOOL delaysTouchesBegan))sk_delaysTouchesBegan
{
    return ^ UIGestureRecognizer* (BOOL delaysTouchesBegan) {
        return ({self.delaysTouchesBegan = delaysTouchesBegan;self;});
    };
}

- (UIGestureRecognizer* (^)(BOOL delaysTouchesEnded))sk_delaysTouchesEnded
{
    return ^ UIGestureRecognizer* (BOOL delaysTouchesEnded) {
        return ({self.delaysTouchesEnded = delaysTouchesEnded;self;});
    };
}

- (UIGestureRecognizer* (^)(NSArray<NSNumber*>* allowedTouchTypes))sk_allowedTouchTypes
{
    return ^ UIGestureRecognizer* (NSArray<NSNumber*>* allowedTouchTypes) {
        return ({self.allowedTouchTypes = allowedTouchTypes;self;});
    };
}

- (UIGestureRecognizer* (^)(NSArray<NSNumber*>* allowedPressTypes))sk_allowedPressTypes
{
    return ^ UIGestureRecognizer* (NSArray<NSNumber*>* allowedPressTypes) {
        return ({self.allowedPressTypes = allowedPressTypes;self;});
    };
}

#pragma mark- private
- (void)recognizerAction:(__kindof UIGestureRecognizer*)recognizer
{

    void(^block)(__kindof UIGestureRecognizer* recognizer) = objc_getAssociatedObject(recognizer, (__bridge const void *)(recognizer));
    block(recognizer);
}

@end

@implementation UIGestureRecognizer (StreamDelegate)

UIKIT_STATIC_INLINE NSDictionary* StreamMethodAndProtocol()
{
    static NSDictionary* streamMethodAndProtocol = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamMethodAndProtocol = @{@"gestureRecognizerShouldBegin:":@"sk_gestureShouldBegin",
                                    @"gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:":@"sk_gestureShouldRecognizeSimultaneously",
                                    @"gestureRecognizer:shouldRequireFailureOfGestureRecognizer:":@"sk_gestureShouldRequireFailure",
                                    @"gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:":@"sk_gestureShouldBeRequiredToFail",
                                    @"gestureRecognizer:shouldReceiveTouch:":@"sk_gestureShouldReceiveTouch",
                                    @"gestureRecognizer:shouldReceivePress:":@"sk_gestureshouldReceivePress"
                                    };
    });
    return streamMethodAndProtocol;
}

+ (void)load
{
    [StreamMethodAndProtocol() enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        StreamSetImplementationToDelegateMethod(objc_getClass("UIGestureRecognizer"), @protocol(UIGestureRecognizerDelegate), obj.UTF8String, key.UTF8String);
    }];
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer)))sk_gestureShouldBegin
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer)){
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldRecognizeSimultaneously
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldRequireFailure
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldBeRequiredToFail
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UITouch* touch)))sk_gestureShouldReceiveTouch
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer,UITouch* touch)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIPress* press)))sk_gestureshouldReceivePress
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer,UIPress* press)) {
        StreamDelegateBindBlock(_cmd, self, block);
        return self;
    };
}

@end
