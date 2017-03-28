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
(((void)(NO && ((void)path,NO)),strchr(# path,'.')+1))

#define sk_keypath2(obj,path) \
(((void)(NO && ((void)obj.path,NO)),# path))

#define KVC(obj,...) \


#endif /* SKKeyPathMarco_h */
