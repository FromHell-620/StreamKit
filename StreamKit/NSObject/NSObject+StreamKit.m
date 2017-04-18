//
//  NSObject+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "NSObject+StreamKit.h"
#import "SKObjectifyMarco.h"
#import <UIKit/UIKit.h>
@import ObjectiveC.runtime;
@import ObjectiveC.message;

@implementation NSObject (StreamProtocol)

FOUNDATION_STATIC_INLINE char* disposeMethodType(const char* type)
{
    NSCParameterAssert(type);
    char* result = strdup(type);
    char* desk = result;
    char* src = result;
    while (*src) {
        if (isdigit(*src)) {src++;continue;};
        *desk++ = *src++;
    }
    *desk = '\0';
    return result;
}

FOUNDATION_STATIC_INLINE const char* compatibility_type(const char* type) {
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    return type;
#else
    if (strcasecmp(type, "B@:@") == 0) {
        return "c@:@";
    }else if(strcasecmp(type, "v@:@") == 0) {
        return "v@:@";
    }else if(strcasecmp(type, "v@:@q") == 0) {
        return "v@:@q";
    }else if(strcasecmp(type, "B@:@{_NSRange=QQ}@")){
        return "c@:@{_NSRange=II}@";
    }else if (strcasecmp(type, "v@:@{CGPoint=dd}N^{CGPoint=dd}")) {
        return "v@:@{CGPoint=ff}N^{CGPoint=ff}";
    }else if (strcasecmp(type, "v@:@B")) {
        return "v@:@c";
    }else if (strcasecmp(type, "@@:@")) {
        return "@@:@";
    }else if (strcasecmp(type, "v@:@@")) {
        return "v@:@@";
    }else if (strcasecmp(type, "v@:@@d")) {
        return "v@:@@f";
    }else if(strcasecmp(type, "B@:@@")) {
        return "c@:@@";
    }
    return NULL;
#endif
}

void StreamInitializeDelegateMethod(Class cls,Protocol* protocol,const char* protocol_method_name,const void* AssociatedKey)
{
    NSCParameterAssert(protocol);
    NSCParameterAssert(protocol_method_name);
    SEL sel = sel_registerName(protocol_method_name);
    if (class_getInstanceMethod(cls, sel)) {
        return;
    }
    struct objc_method_description desc = protocol_getMethodDescription(protocol, sel, NO, YES);
    IMP imp = NULL;
    char* type = disposeMethodType(desc.types);
    if (strcasecmp(type, compatibility_type("B@:@")) == 0) {
        imp = imp_implementationWithBlock(^BOOL( id target,id param) {
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                return sk_objcmsgSend(BOOL(*)(id,SEL,id),realDelegate,desc.name,param);
            }
            BOOL(^block)(id) = objc_getAssociatedObject(target, AssociatedKey);
            return !block?YES:block(param);
        });
    }else if (strcasecmp(type, compatibility_type("v@:@")) == 0) {
        imp = imp_implementationWithBlock(^(id target,id param) {
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                ((void(*)(id,SEL,id))objc_msgSend)(realDelegate,desc.name,param);
            }
            void(^block)(id) = objc_getAssociatedObject(target, AssociatedKey);
            !block?:block(param);
        });
    }else if (strcasecmp(type, compatibility_type("v@:@q")) == 0) {
        imp = imp_implementationWithBlock(^(id target,id param,long l){
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                sk_objcmsgSend(void(*)(id,SEL,id,long),realDelegate,desc.name,param,l);
            }
            void(^block)(id,long) = objc_getAssociatedObject(target, AssociatedKey);
            !block?:block(param,l);
        });
    }else if (strcasecmp(type, compatibility_type("B@:@{_NSRange=QQ}@")) == 0) {
        imp = imp_implementationWithBlock(^BOOL(id target,id param1,NSRange range,id param2){
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                return sk_objcmsgSend(BOOL(*)(id,SEL,id,NSRange,id),realDelegate,desc.name,param1,range,param2);
            }
            BOOL(^block)(id,NSRange,id) = objc_getAssociatedObject(target, AssociatedKey);
            return !block?YES:block(param1,range,param2);
        });
    }else if (strcasecmp(type, compatibility_type("v@:@{CGPoint=dd}N^{CGPoint=dd}")) == 0) {
        imp = imp_implementationWithBlock(^(id target,id param,CGPoint point1,CGPoint* point2) {
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                sk_objcmsgSend(void(*)(id,SEL,id,CGPoint,CGPoint*),realDelegate,desc.name,param,point1,point2);
            }
            void(^block)(id,CGPoint,CGPoint*) = objc_getAssociatedObject(target, AssociatedKey);
            block(param,point1,point2);
        });
    }else if (strcasecmp(type, compatibility_type("v@:@B")) == 0) {
        imp = imp_implementationWithBlock(^(id target,id param,BOOL b){
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                sk_objcmsgSend(void(*)(id,SEL,id,BOOL),realDelegate,desc.name,param,b);
            }
            void(^block)(id,BOOL) = objc_getAssociatedObject(target, AssociatedKey);
            !block?:block(param,b);
        });
    }else if (strcasecmp(type, compatibility_type("@@:@")) == 0) {
        imp = imp_implementationWithBlock(^id(id target,id param) {
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                return sk_objcmsgSend(id(*)(id,SEL,id),realDelegate,desc.name,param);
            }
            id(^block)(id) = objc_getAssociatedObject(target, AssociatedKey);
            return !block?nil:block(param);
        });
    }else if (strcasecmp(type, compatibility_type("v@:@@")) == 0) {
        imp = imp_implementationWithBlock(^(id target,id param1,id param2){
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                sk_objcmsgSend(void(*)(id,SEL,id,id),realDelegate,desc.name,param1,param2);
            }
            void(^block)(id,id) = objc_getAssociatedObject(target, AssociatedKey);
            !block?:block(param1,param2);
        });
    }else if (strcasecmp(type, compatibility_type("v@:@@d")) == 0) {
        imp = imp_implementationWithBlock(^(id target,id param,float f) {
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                sk_objcmsgSend(void(*)(id,SEL,id,float),realDelegate,desc.name,param,f);
            }
            void(^block)(id,float) = objc_getAssociatedObject(target, AssociatedKey);
            !block?:block(param,f);
        });
    }else if (strcasecmp(type, compatibility_type("B@:@@")) == 0) {
        imp = imp_implementationWithBlock(^BOOL(id target,id param1,id param2) {
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                return sk_objcmsgSend(BOOL(*)(id,SEL,id,id),realDelegate,desc.name,param1,param2);
            }
            BOOL(^block)(id,id) = objc_getAssociatedObject(target, AssociatedKey);
            return !block?YES:block(param1,param2);
        });
    }
    free(type);
    if (imp) {
        class_addMethod(cls, desc.name, imp, desc.types);
    }
}

void StreamDelegateBindBlock(SEL method,NSObject* delegateObject,id block)
{
    NSCParameterAssert((__bridge const void*)delegateObject);
    NSCParameterAssert((__bridge const void*)block);
    SEL get_delegate_sel = sel_registerName("delegate");
    id realDelegate = sk_objcmsgSend(id(*)(id,SEL),delegateObject,get_delegate_sel);
    if (realDelegate != delegateObject) {
        SEL set_delegate_sel = sel_registerName("setDelegate:");
        sk_objcmsgSend(void(*)(id,SEL,id),delegateObject,set_delegate_sel,delegateObject);
        objc_setAssociatedObject(delegateObject, (__bridge const void*)delegateObject, realDelegate, OBJC_ASSOCIATION_ASSIGN);
    }
    objc_setAssociatedObject(delegateObject, method, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

void StreamDataSourceBindBlock(SEL method,NSObject* dataSourceObject,id block)
{
    NSCParameterAssert((__bridge const void*)dataSourceObject);
    NSCParameterAssert((__bridge const void*)block);
    SEL get_dataSource_sel = sel_registerName("dataSource");
    id realDataSource = sk_objcmsgSend(id(*)(id,SEL),dataSourceObject,get_dataSource_sel);
    if (realDataSource != dataSourceObject) {
        SEL set_dataSource_sel = sel_registerName("setDataSource:");
        sk_objcmsgSend(void(*)(id,SEL,id),dataSourceObject,set_dataSource_sel,dataSourceObject);
    }
    objc_setAssociatedObject(dataSourceObject, method, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

void StreamSetImplementationToDelegateMethod(Class cls,Protocol* protocol,const char* method_name,const char* protocol_method_name)
{
    NSCParameterAssert(method_name);
    NSCParameterAssert(protocol_method_name);
    SEL sel = sel_registerName(method_name);
    __block id (*originalImp)(__unsafe_unretained id ,SEL) = NULL;
    id (^newImp)(__unsafe_unretained id target) = ^ id (__unsafe_unretained id target){
        StreamInitializeDelegateMethod(cls, protocol, protocol_method_name, sel_getUid(method_name));
        if (originalImp) return originalImp(target,sel);
        else return nil;
    };
    originalImp = (id(*)(__unsafe_unretained id,SEL))method_setImplementation(class_getInstanceMethod(cls, sel), imp_implementationWithBlock(newImp));
}

void StreamHookMehtod(Class hookClass,const char* hookMethodName,void(^aspectBlock)(id target))
{
    NSCParameterAssert(hookMethodName);
    SEL hook_method = sel_registerName(hookMethodName);
    __block void(*original_method)(__unsafe_unretained id,SEL) = NULL;
    IMP hook_imp = imp_implementationWithBlock(^(__unsafe_unretained id target) {
        !aspectBlock?:aspectBlock(target);
        if (!original_method) {
            struct objc_super super_objc = {
                .receiver = target,
#if !defined(__cplusplus)  &&  !__OBJC2__
                .class = hookClass,
#else
                .super_class = class_getSuperclass(hookClass)
#endif
            };
            ((void(*)(void*,SEL))objc_msgSendSuper)(&super_objc,hook_method);
            return ;
        }
        original_method(target,hook_method);
    });
    if (!class_addMethod(hookClass, hook_method, hook_imp, "v@:")) {
        original_method = (void(*)(__unsafe_unretained id,SEL))method_setImplementation(class_getInstanceMethod(hookClass, hook_method), hook_imp);
    }
    
}

@end

static const void* StreamObserverKey = &StreamObserverKey;

static void* StreamObserverContextKey = &StreamObserverContextKey;

@implementation NSObject (StreamKit)

- (NSObject*(^)(NSString* keyPath,void(^block)(NSDictionary* change)))sk_addObserverWithKeyPath
{
    return ^NSObject* (NSString* keyPath,void(^block)(NSDictionary* change)) {
        NSParameterAssert(keyPath);
        NSParameterAssert(block);
        Class hook_class = object_getClass(self);
        static NSMutableSet* hookClassCaches = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            hookClassCaches = [NSMutableSet set];
        });
        if (![hookClassCaches containsObject:hook_class]) {
            StreamHookMehtod(hook_class, "dealloc", ^(NSObject* target){
                target.sk_removeAllObserver();
            });
            [hookClassCaches addObject:hook_class];
        }
        
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:StreamObserverContextKey];
        NSMutableDictionary* blocks = objc_getAssociatedObject(self, StreamObserverKey);
        if (!blocks) {
            blocks = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(self, StreamObserverKey, blocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [blocks setObject:block forKey:keyPath];
        return self;
    };
}

- (NSObject*(^)(NSString* keyPath))sk_removeOvserverWithKeyPath
{
    return ^NSObject* (NSString* keyPath) {
        NSParameterAssert(keyPath);
        [self removeObserver:self forKeyPath:keyPath];
        NSMutableDictionary* blocks = objc_getAssociatedObject(self, StreamObserverKey);
        [blocks removeObjectForKey:keyPath];
        return self;
    };
}

- (NSObject*(^)())sk_removeAllObserver
{
    return ^NSObject* {
        NSMutableDictionary* blocks = objc_getAssociatedObject(self, StreamObserverKey);
        [blocks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self removeObserver:self forKeyPath:key];
        }];
        [blocks removeAllObjects];
        return self;
    };
}

#pragma mark- Private
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context != StreamObserverContextKey) return;
    NSMutableDictionary* blocks = objc_getAssociatedObject(self, StreamObserverKey);
    void(^block)(NSDictionary* change) = [blocks objectForKey:keyPath];
    !block?:block(change);
}

@end
