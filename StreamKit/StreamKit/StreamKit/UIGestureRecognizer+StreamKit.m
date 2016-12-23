//
//  UIGestureRecognizer+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/19.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "UIGestureRecognizer+StreamKit.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+StreamKit.h"

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

UIKIT_STATIC_INLINE const char* compatibility_type(const char* type) {
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    return type;
#else
    if (strcasecmp(type, "B24@0:8@16") == 0) {
        return "c12@0:4@8";
    }else if(strcasecmp(type, "B32@0:8@16@24") == 0) {
        return "c16@0:4@8@12";
    }
#endif
    return NULL;
}

UIKIT_STATIC_INLINE IMP setupDelegateImplementationWithMethodTypeDesc(const struct objc_method_description method_desc)
{
    IMP imp = NULL;
    SEL Associated_key = sel_registerName([StreamMethodAndProtocol()[[NSString stringWithUTF8String:sel_getName(method_desc.name)]] UTF8String]);
    if (strcasecmp(method_desc.types, compatibility_type("B24@0:8@16")) == 0) {
        imp = imp_implementationWithBlock(^BOOL(id target,UIGestureRecognizer* recognizer) {
            id<UIGestureRecognizerDelegate> realDelegate = objc_getAssociatedObject(target, (__bridge const void *)(target));
            if (realDelegate && [realDelegate respondsToSelector:method_desc.name]) {
                return ((BOOL(*)(id,SEL,id))objc_msgSend)(target,method_desc.name,recognizer);
            }
            
            BOOL (^block)(UIGestureRecognizer* recognizer) = objc_getAssociatedObject(target, Associated_key);
            if (block) return block(recognizer);
            return YES;
        });
    }else {
        imp = imp_implementationWithBlock(^BOOL(id target,UIGestureRecognizer* recognizer,id otherObject){
            id<UIGestureRecognizerDelegate> realDelegate = objc_getAssociatedObject(target, (__bridge const void *)(target));
            if (realDelegate && [realDelegate respondsToSelector:method_desc.name]) {
                return ((BOOL(*)(id,SEL,id,id))objc_msgSend)(target,method_desc.name,recognizer,otherObject);
            }
            
            BOOL (^block)(UIGestureRecognizer* recognizer,id otherObject) = objc_getAssociatedObject(target, Associated_key);
            if (block) return block(recognizer,otherObject);
            return YES;
        });
    }
    return imp;
}


UIKIT_STATIC_INLINE void initializeDelegateMethod(const char* protocol_method_name)
{
    Class cls = objc_getClass("UITextField");
    StreamInitializeDelegateMethod(cls, "UIGestureRecognizerDelegate", protocol_method_name, setupDelegateImplementationWithMethodTypeDesc);
}

+ (void)load
{
    [StreamMethodAndProtocol() enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        StreamSetImplementationToMethod(objc_getClass("UIGestureRecognizer"), obj.UTF8String, key.UTF8String, initializeDelegateMethod);
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
