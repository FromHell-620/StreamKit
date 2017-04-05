//
//  SKMetaMarco.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/28.
//  Copyright © 2017年 李浩. All rights reserved.
//

#ifndef SKMetaMarco_h
#define SKMetaMarco_h


#define sk_concat_(A,B) A ## B

#define sk_concat(A,B) sk_concat_(A,B)

#define sk_stringify_(A) # A

#define sk_arg(_1,_2,_3,_4,_5,_6,_7,_8,_9,_10,...) _10

#define sk_argcount_(...) sk_arg(__VA_ARGS__,9,8,7,6,5,4,3,2,1,0)

#define sk_argcount(...) sk_argcount_(__VA_ARGS__)

#define SK_PASTEARG2(A,B) sk_concat(A,B)

#define SK_PASTEARG3(A,B,C) \
    SK_PASTEARG2(SK_PASTEARG2(A,B),C)

#define SK_PASTEARG4(A,B,C,D) \
    SK_PASTEARG2(SK_PASTEARG3(A,B,C),D)

#define SK_PASTEARG5(A,B,C,D,E) \
    SK_PASTEARG2(SK_PASTEARG4(A,B,C,D),E)

#define SK_PASTEARG6(A,B,C,D,E,F) \
    SK_PASTEARG2(SK_PASTEARG5(A,B,C,D,E),F)

#define SK_PASTEARG7(A,B,C,D,E,F,G) \
    SK_PASTEARG2(SK_PASTEARG6(A,B,C,D,E,F),G)

#define SK_PASTEARG8(A,B,C,D,E,F,G,H) \
    SK_PASTEARG2(SK_PASTEARG7(A,B,C,D,E,F,G),H)

#define SK_PASTEARG9(A,B,C,D,E,F,G,H,I) \
    SK_PASTEARG2(SK_PASTEARG8(A,B,C,D,E,F,G,H),I)

#define sk_argconsume_(...)

#define sk_argexpand_(...) __VA_ARGS__

#define sk_argcount_if_1(...) \
    __VA_ARGS__ \
    sk_argconsume_

#define sk_argcount_if_2(...) \
    sk_argexpand_

#define sk_argcount_if_3(...) \
    sk_argexpand_

#define foreach_argcount_if_1(key,_0) \
    key(_0)

#define foreach_argcount_if_2(key,_0,_1) \
    foreach_argcount_if_1(key,_0) \
    key(_1)

#define foreach_argcount_if_3(key,_0,_1,_3) \
    foreach_argcount_if_2(key,_0,_1) \
    key(_3)

#define foreach_argcount_if_4(key,_0,_1,_3,_4) \
    foreach_argcount_if_3(key,_0,_1,_3) \
    key(_4)

#define foreach_argcount_if_5(key,_0,_1,_3,_4,_5) \
    foreach_argcount_if_4(key,_0,_1,_3,_4) \
    key(_5)

#define foreach_argcount_if_6(key,_0,_1,_3,_4,_5,_6) \
    foreach_argcount_if_5(key,_0,_1,_3,_4,_5) \
    key(_6)

#define foreach_argcount_if_7(key,_0,_1,_3,_4,_5,_6,_7) \
    foreach_argcount_if_6(key,_0,_1,_3,_4,_5,_6) \
    key(_7)

#define foreach_argcount_if_8(key,_0,_1,_3,_4,_5,_6,_7,_8) \
    foreach_argcount_if_7(key,_0,_1,_3,_4,_5,_6,_7) \
    key(_8)

#define foreach_argcount_if_9(key,_0,_1,_3,_4,_5,_6,_7,_8,_9) \
    foreach_argcount_if_8(key,_0,_1,_3,_4,_5,_6,_7,_8) \
    key(_9)

#if DEBUG
#define sk_keywordify autoreleasepool {}
#else
#define sk_keywordify try {} @catch (...) {}
#endif

#endif /* SKMetaMarco_h */
