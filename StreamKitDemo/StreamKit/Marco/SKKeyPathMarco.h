//
//  SKKeyPathMarco.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/28.
//  Copyright © 2017年 李浩. All rights reserved.
//

#ifndef SKKeyPathMarco_h
#define SKKeyPathMarco_h

#define sk_keypath(...) \
    SK_PASTEARG2(sk_argcount_if_,sk_argcount(__VA_ARGS__))(sk_keypath1(__VA_ARGS__))(sk_keypath2(__VA_ARGS__))

#define sk_keypath1(path) \
    (((void)(NO && ((void)path,NO)),strchr(sk_stringify(path),'.')+1))

#define sk_keypath2(obj,path) \
    (((void)(NO && ((void)obj.path,NO)),sk_stringify(path)))

#define sk_selector(obj,sel) \
(((void)(NO && ((void)[obj performSelector:@selector(sel)],NO)),sk_stringify(sel)))

#define SK_(obj,keypath,nil_Value) \
    [[SKSubscribringObserverTrampoline alloc] initWithObject:(obj) nilValue:(nil_Value)][@sk_keypath(obj,keypath)]

#define SKObserve_(obj,keypath) \
    [[obj sk_observerWithKeyPath:@sk_keypath(obj,keypath)] map:^id(id x) { \
        return [x objectForKey:@"new"]; \
    }]

#define SK(obj,...) \
    SK_PASTEARG2(sk_argcount_if_,sk_argcount(__VA_ARGS__)) \
    (SK_(obj,__VA_ARGS__,nil))(SK_(obj,__VA_ARGS__))

#define SKObserve(obj,...) \
    SK_PASTEARG2(sk_argcount_if_,sk_argcount(__VA_ARGS__)) \
    (SKObserve_(obj,__VA_ARGS__)) \
    (SKObserve_(obj,__VA_ARGS__))

#define SKSelector(obj,sel) \
    [[SKSubscribringSelectorTrampoline alloc] initWithTarget:(obj)] \
        [@sk_selector(obj,sel)]

#endif /* SKKeyPathMarco_h */
