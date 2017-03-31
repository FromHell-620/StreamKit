//
//  SKObjectifyMarco.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/28.
//  Copyright © 2017年 李浩. All rights reserved.
//

#ifndef SKObjectifyMarco_h
#define SKObjectifyMarco_h

#define SK_ClassForceify(obj,Class) \
    (NO && ((void)[Class class],NO),((Class*)obj))

#define SK_BasicForceify(value,type) \
    ((type)value)

#define sk_objcmsgSend(type,...) \
    SK_BasicForceify(objc_msgSend,type)(__VA_ARGS__)

#define sk_stringify(A) sk_stringify_(A)

#define sk_classify(Class) \
    @(((NO&&((void)[Class class],NO)),# Class)).sk_classify

#endif /* SKObjectifyMarco_h */
