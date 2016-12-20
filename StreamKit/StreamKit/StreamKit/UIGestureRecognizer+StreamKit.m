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

static const void* block_key = &block_key;

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
            static NSMapTable* cacheRecognizer = nil;
            static dispatch_semaphore_t lock = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                cacheRecognizer = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory];
                lock = dispatch_semaphore_create(1);
                objc_setAssociatedObject(class_getSuperclass(object_getClass(self)), block_key, cacheRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            });
            NSMutableSet* blocks = [cacheRecognizer objectForKey:self];
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            if (!blocks) {
                blocks = [NSMutableSet set];
                [cacheRecognizer setObject:blocks forKey:self];
            }
            [blocks addObject:block];
            dispatch_semaphore_signal(lock);
            [self addTarget:self action:@selector(recognizerAction:)];
        }
        return self;
    };
}

- (UIGestureRecognizer* (^)())sk_removeTargetBlock
{
    return ^ UIGestureRecognizer* {
        NSMapTable* cacheRecognizer = objc_getAssociatedObject(class_getSuperclass(object_getClass(self)), block_key);
        [cacheRecognizer removeObjectForKey:self];
        return self;
    };
}

- (UIGestureRecognizer* (^)())sk_clearTargetBlock
{
    return ^ UIGestureRecognizer* {
        NSMapTable* cacheRecognizer = objc_getAssociatedObject(class_getSuperclass(object_getClass(self)), block_key);
        [cacheRecognizer removeAllObjects];
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
    NSMapTable* cacheRecognizer = objc_getAssociatedObject(class_getSuperclass(object_getClass(self)), block_key);
    NSMutableSet* blocks = [cacheRecognizer objectForKey:recognizer];
    [blocks enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        void(^block)(__kindof UIGestureRecognizer* recognizer) = obj;
        block(recognizer);
    }];
}

@end

static const NSString* protocol_name = @"UIGestureRecognizerDelegate";

static const void* realDelegate_key = &realDelegate_key;

static const void* UIGestureRecognizerShouldBegin = &UIGestureRecognizerShouldBegin;

static const void* UIGestureRecognizershouldRecognizeSimultaneously = &UIGestureRecognizershouldRecognizeSimultaneously;

static const void* UIGestureRecognizerShouldRequireFailure = &UIGestureRecognizerShouldRequireFailure;

static const void* UIGestureRecognizerShouldBeRequiredToFail = &UIGestureRecognizerShouldBeRequiredToFail;

static const void* UIGestureRecognizerShouldReceiveTouch = &UIGestureRecognizerShouldReceiveTouch;

static const void* UIGestureRecognizerShouldReceivePress = &UIGestureRecognizerShouldReceivePress;

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

UIKIT_STATIC_INLINE NSDictionary* StreamMethodWithAssociatedKeys()
{
    static NSDictionary* streamMethodWithAssociatedKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamMethodWithAssociatedKeys = @{@"sk_gestureShouldBegin":(__bridge id)UIGestureRecognizerShouldBegin,
          @"sk_gestureShouldRecognizeSimultaneously":(__bridge id)UIGestureRecognizershouldRecognizeSimultaneously,
          @"sk_gestureShouldRequireFailure":(__bridge id)UIGestureRecognizerShouldRequireFailure,
          @"sk_gestureShouldBeRequiredToFail":(__bridge id)UIGestureRecognizerShouldBeRequiredToFail,
          @"sk_gestureShouldReceiveTouch":(__bridge id)UIGestureRecognizerShouldReceiveTouch,
          @"sk_gestureshouldReceivePress":(__bridge id)UIGestureRecognizerShouldReceivePress
                                           };
    });
    return streamMethodWithAssociatedKeys;
}

UIKIT_STATIC_INLINE const char* StreamMethodWithProtocolName(const char* protocol_name)
{
    return (__bridge const void*)(StreamMethodAndProtocol()[[NSString stringWithUTF8String:protocol_name]]);
}

UIKIT_STATIC_INLINE const void* AssociatedKeyWithMethodName(const char* name)
{
    NSString* method_name = [NSString stringWithUTF8String:name];
    return (__bridge const void *)(StreamMethodWithAssociatedKeys()[method_name]);
}

UIKIT_STATIC_INLINE void StreamMethodBindBlock(const char* methodName,UIGestureRecognizer* recognizer,id block)
{
    if (block) {
        id<UIGestureRecognizerDelegate> realDelegate = recognizer.delegate;
        if (realDelegate != recognizer) {
            ((void(*)(id,SEL,id))objc_msgSend)(recognizer,sel_registerName("setDelegate:"),recognizer);
            objc_setAssociatedObject(recognizer, realDelegate_key, realDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        objc_setAssociatedObject(recognizer, AssociatedKeyWithMethodName(methodName), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
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

UIKIT_STATIC_INLINE void StreamInitializeDelegateMethod(const char* protocol_method_name)
{
    NSCParameterAssert(protocol_method_name);
    if (class_getInstanceMethod(objc_getClass("UIGestureRecognizer"), sel_registerName(protocol_method_name))) {
        return;
    }
    
    struct objc_method_description desc = protocol_getMethodDescription(objc_getProtocol(protocol_name.UTF8String), sel_registerName(protocol_method_name), NO, YES);
    IMP imp = nil;
    if (strcasecmp(desc.types, compatibility_type("B24@0:8@16"))) {
        imp = imp_implementationWithBlock(^BOOL(id target,UIGestureRecognizer* recognizer) {
            id<UIGestureRecognizerDelegate> realDelegate = objc_getAssociatedObject(target, realDelegate_key);
            if (realDelegate && [realDelegate respondsToSelector:desc.name]) {
                return ((BOOL(*)(id,SEL,id))objc_msgSend)(target,desc.name,recognizer);
            }
            
            BOOL (^block)(UIGestureRecognizer* recognizer) = objc_getAssociatedObject(target, AssociatedKeyWithMethodName(StreamMethodWithProtocolName(sel_getName(desc.name))));
            if (block) return block(recognizer);
            return YES;
        });
    }else if (strcasecmp(desc.types, compatibility_type("B32@0:8@16@24"))) {
        imp = imp_implementationWithBlock(^BOOL(id target,UIGestureRecognizer* recognizer,id otherObject){
            id<UIGestureRecognizerDelegate> realDelegate = objc_getAssociatedObject(target, realDelegate_key);
            if (realDelegate && [realDelegate respondsToSelector:desc.name]) {
                return ((BOOL(*)(id,SEL,id,id))objc_msgSend)(target,desc.name,recognizer,otherObject);
            }
            
            BOOL (^block)(UIGestureRecognizer* recognizer,id otherObject) = objc_getAssociatedObject(target, AssociatedKeyWithMethodName(StreamMethodWithProtocolName(sel_getName(desc.name))));
            if (block) return block(recognizer,otherObject);
            return YES;
        });
    }
    
    NSCParameterAssert(imp);
    class_addMethod(objc_getClass("UIGestureRecognizer"), desc.name, imp, desc.types);
    
}

+ (void)load
{
    [StreamMethodAndProtocol() enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        SEL stream_sel = sel_registerName(obj.UTF8String);
        id (*originalImp)(__unsafe_unretained id ,SEL) = NULL;
        id (^newImp)(__unsafe_unretained id target) = ^ id (__unsafe_unretained id target){
            StreamInitializeDelegateMethod(key.UTF8String);
            if (originalImp) return originalImp(target,stream_sel);
            else return nil;
        };
        originalImp = (id(*)(__unsafe_unretained id,SEL))method_setImplementation(class_getInstanceMethod(objc_getClass("UIGestureRecognizer"), stream_sel), imp_implementationWithBlock(newImp));
    }];
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer)))sk_gestureShouldBegin
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer)){
        StreamMethodBindBlock(sel_getName(_cmd), self, block);
        return self;
    };
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldRecognizeSimultaneously
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)) {
        StreamMethodBindBlock(sel_getName(_cmd), self, block);
        return self;
    };
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldRequireFailure
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)) {
        StreamMethodBindBlock(sel_getName(_cmd), self, block);
        return self;
    };
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)))sk_gestureShouldBeRequiredToFail
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer,UIGestureRecognizer* otherRecognizer)) {
        StreamMethodBindBlock(sel_getName(_cmd), self, block);
        return self;
    };
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UITouch* touch)))sk_gestureShouldReceiveTouch
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer,UITouch* touch)) {
        StreamMethodBindBlock(sel_getName(_cmd), self, block);
        return self;
    };
}

- (UIGestureRecognizer* (^)(BOOL(^block)(UIGestureRecognizer* recognizer,UIPress* press)))sk_gestureshouldReceivePress
{
    return ^ UIGestureRecognizer* (BOOL(^block)(UIGestureRecognizer* recognizer,UIPress* press)) {
        StreamMethodBindBlock(sel_getName(_cmd), self, block);
        return self;
    };
}

@end
