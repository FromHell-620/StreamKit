//
//  NSObject+StreamKit.m
//  StreamKit
//
//  Created by 苏南 on 16/12/22.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "NSObject+StreamKit.h"
#import <objc/runtime.h>

typedef IMP (*implementation)(const struct objc_method_description method_desc);

@implementation NSObject (StreamKit)

NS_INLINE void StreamInitializeDelegateMethod(Class cls,const char* protocol_name,const char* protocol_method_name,implementation initializeIMP,bool isRequiredMethod)
{
    NSCParameterAssert(protocol_name);
    NSCParameterAssert(protocol_method_name);
    SEL sel = sel_registerName(protocol_method_name);
    if (class_getInstanceMethod(cls, sel)) {
        return;
    }
    
    Protocol* protocol = objc_getProtocol(protocol_name);
    struct objc_method_description desc = protocol_getMethodDescription(protocol, sel, isRequiredMethod, YES);
    IMP imp = initializeIMP(desc);
    if (imp) {
        class_addMethod(cls, desc.name, imp, desc.types);
    }
}

@end
