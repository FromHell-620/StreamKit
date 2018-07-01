//
//  SKObjectifyMarco.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/28.
//  Copyright © 2017年 李浩. All rights reserved.
//

#ifndef SKObjectifyMarco_h
#define SKObjectifyMarco_h

#import "SKMetaMarco.h"

typedef void (^sk_cleanupBlock_t)(void);

static inline void sk_executeCleanupBlock (__strong sk_cleanupBlock_t *block) {
    (*block)();
}

#define SK_ClassForceify(obj,Class) \
    (NO && ((void)[Class class],NO),((Class*)obj))

#define SK_BasicForceify(value,type) \
    ((type)value)

#define sk_objcmsgSend(type,...) \
    SK_BasicForceify(objc_msgSend,type)(__VA_ARGS__)

#define sk_stringify(A) sk_stringify_(A)

#define sk_classify(Class) \
    @(((NO&&((void)[Class class],NO)),# Class)).sk_classify

#define weakify_(VAR) \
    __weak __typeof__(VAR) SK_PASTEARG2(weak_,VAR) = (VAR);

#define unsafeify_(VAR) \
    __unsafe_unretained __typeof__(VAR) SK_PASTEARG2(weak_,VAR) = (VAR);

#define strongify_(VAR) \
    __strong __typeof__(VAR) (VAR) = SK_PASTEARG2(weak_,VAR);

#define onExit \
    sk_keywordify \
        __strong sk_cleanupBlock_t sk_concat(sk_exitBlock_,__LINE__) __attribute__((cleanup(sk_executeCleanupBlock), unused)) = ^

#define weakify(...) \
    sk_keywordify \
     SK_PASTEARG2(foreach_argcount_if_,sk_argcount(__VA_ARGS__))(weakify_,__VA_ARGS__)

#define unsafeify(...) \
    sk_keywordify \
    SK_PASTEARG2(foreach_argcount_if_,sk_argcount(__VA_ARGS__))(unsafeify_,__VA_ARGS__)

#define strongify(...) \
    sk_keywordify \
    SK_PASTEARG2(foreach_argcount_if_,sk_argcount(__VA_ARGS__))(strongify_,__VA_ARGS__)

#define mapify(...) {SK_PASTEARG2(mapify_argcount_if_,sk_argcount(__VA_ARGS__))(__VA_ARGS__)}
#endif /* SKObjectifyMarco_h */
