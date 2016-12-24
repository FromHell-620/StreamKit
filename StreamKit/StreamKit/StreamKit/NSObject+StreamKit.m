//
//  NSObject+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "NSObject+StreamKit.h"
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

void StreamInitializeDelegateMethod(Class cls,const char* protocol_name,const char* protocol_method_name,const void* AssociatedKey)
{
    NSCParameterAssert(protocol_name);
    NSCParameterAssert(protocol_method_name);
    SEL sel = sel_registerName(protocol_method_name);
    if (class_getInstanceMethod(cls, sel)) {
        return;
    }
    Protocol* protocol = objc_getProtocol(protocol_name);
    struct objc_method_description desc = protocol_getMethodDescription(protocol, sel, NO, YES);
    IMP imp = NULL;
    char* type = disposeMethodType(desc.types);
    if (strcasecmp(type, compatibility_type("B@:@")) == 0) {
        imp = imp_implementationWithBlock(^BOOL(id target,id param) {
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                return ((BOOL(*)(id,SEL,id))objc_msgSend)(target,desc.name,param);
            }
            BOOL(^block)(id object) = objc_getAssociatedObject(target, AssociatedKey);
            return !block?YES:block(param);
        });
    }else if (strcasecmp(type, compatibility_type("v@:@")) == 0) {
        imp = imp_implementationWithBlock(^(id target,id param) {
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                ((void(*)(id,SEL,id))objc_msgSend)(target,desc.name,param);
            }
            void(^block)(id object) = objc_getAssociatedObject(target, AssociatedKey);
            block(param);
        });
    }else if (strcasecmp(type, compatibility_type("v@:@q")) == 0) {
        imp = imp_implementationWithBlock(^(id target,id param,long l){
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                ((void(*)(id,SEL,id,long))objc_msgSend)(target,desc.name,param,l);
            }
            void(^block)(id object,long l) = objc_getAssociatedObject(target, AssociatedKey);
            block(param,l);
        });
    }else if (strcasecmp(type, compatibility_type("B@:@{_NSRange=QQ}@")) == 0) {
        imp = imp_implementationWithBlock(^BOOL(id target,id param1,NSRange range,id param2){
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                return ((BOOL(*)(id,SEL,id,NSRange,id))objc_msgSend)(target,desc.name,param1,range,param2);
            }
            BOOL(^block)(id object1,NSRange range,id object2) = objc_getAssociatedObject(target, AssociatedKey);
            return !block?YES:block(param1,range,param2);
        });
    }else if (strcasecmp(type, compatibility_type("v@:@{CGPoint=dd}N^{CGPoint=dd}")) == 0) {
        imp = imp_implementationWithBlock(^(id target,id param,CGPoint point1,CGPoint* point2) {
            id realDelegate = objc_getAssociatedObject(target, (__bridge const void*)target);
            if (realDelegate&&[realDelegate respondsToSelector:desc.name]) {
                ((void(*)(id,SEL,id,CGPoint,CGPoint*))objc_msgSend)(target,desc.name,param,point1,point2);
            }
            void(^block)(id object,CGPoint point1,CGPoint* point2) = objc_getAssociatedObject(target, AssociatedKey);
            block(param,point1,point2);
        });
    }
//    IMP imp = initializeIMP(desc);
    if (imp) {
        class_addMethod(cls, desc.name, imp, desc.types);
    }
}

void StreamDelegateBindBlock(SEL method,NSObject* delegateObject,id block)
{
    NSCParameterAssert((__bridge const void*)delegateObject);
    NSCParameterAssert((__bridge const void*)block);
    SEL get_delegate_sel = sel_registerName("delegate");
    id realDelegate = ((id(*)(id,SEL))objc_msgSend)(delegateObject,get_delegate_sel);
    if (realDelegate != delegateObject) {
        SEL set_delegate_sel = sel_registerName("setDelegate:");
        ((void(*)(id,SEL,id))objc_msgSend)(delegateObject,set_delegate_sel,delegateObject);
        objc_setAssociatedObject(delegateObject, (__bridge const void*)delegateObject, realDelegate, OBJC_ASSOCIATION_ASSIGN);
    }
    objc_setAssociatedObject(delegateObject, method, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

void StreamDataSourceBindBlock(SEL method,NSObject* dataSourceObject,id block)
{
    NSCParameterAssert((__bridge const void*)dataSourceObject);
    NSCParameterAssert((__bridge const void*)block);
    SEL get_dataSource_sel = sel_registerName("dataSource");
    id realDataSource = ((id(*)(id,SEL))objc_msgSend)(dataSourceObject,get_dataSource_sel);
    if (realDataSource != dataSourceObject) {
        SEL set_dataSource_sel = sel_registerName("setDataSource:");
        ((void(*)(id,SEL,id))objc_msgSend)(dataSourceObject,set_dataSource_sel,dataSourceObject);
    }
    objc_setAssociatedObject(dataSourceObject, method, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

void StreamSetImplementationToMethod(Class cls,const char* method_name,const char* protocol_method_name,void(*initializeDelegate)(const char* key))
{
    NSCParameterAssert(method_name);
    NSCParameterAssert(protocol_method_name);
    SEL sel = sel_registerName(method_name);
    __block id (*originalImp)(__unsafe_unretained id ,SEL) = NULL;
    id (^newImp)(__unsafe_unretained id target) = ^ id (__unsafe_unretained id target){
        initializeDelegate(protocol_method_name);
        if (originalImp) return originalImp(target,sel);
        else return nil;
    };
    originalImp = (id(*)(__unsafe_unretained id,SEL))method_setImplementation(class_getInstanceMethod(cls, sel), imp_implementationWithBlock(newImp));
}

@end

@implementation NSObject (StreamKit)

@end
