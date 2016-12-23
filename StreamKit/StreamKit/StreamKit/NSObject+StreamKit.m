//
//  NSObject+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "NSObject+StreamKit.h"
@import ObjectiveC.runtime;
@import ObjectiveC.message;

@implementation NSObject (StreamKit)

 void StreamInitializeDelegateMethod(Class cls,const char* protocol_name,const char* protocol_method_name,implementation initializeIMP)
{
    NSCParameterAssert(protocol_name);
    NSCParameterAssert(protocol_method_name);
    SEL sel = sel_registerName(protocol_method_name);
    if (class_getInstanceMethod(cls, sel)) {
        return;
    }
    Protocol* protocol = objc_getProtocol(protocol_name);
    struct objc_method_description desc = protocol_getMethodDescription(protocol, sel, NO, YES);
    IMP imp = initializeIMP(desc);
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
