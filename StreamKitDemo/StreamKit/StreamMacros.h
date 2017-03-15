//
//  StreamMacros.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/13.
//  Copyright © 2017年 李浩. All rights reserved.
//

#ifndef StreamMacros_h
#define StreamMacros_h

#define sk_concat_(A,B) A ## B
#define sk_concat(A,B) sk_concat_(A,B)

#define sk_stringify_(A) # A
#define sk_stringify(A) sk_stringify_(A)

typedef void(^KVOCallback)(NSDictionary* change);

#define sk_arg(_1,_2,_3,_4,_5,_6,_7,_8,_9,_10,...) _10

#define sk_argcount_(...) sk_arg(__VA_ARGS__,9,8,7,6,5,4,3,2,1,0)

#define sk_argcount(...) sk_argcount_(__VA_ARGS__)

#define sk_blockWords ^

#define sk_observeBlock(...) \
    sk_keywordify \

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

#define sk_typedef(...) \

#define sk_typedefblock(name,returnType,...) \
    sk_classify(returnType) \
    typedef returnType  (^callback) ()
//    sk_concat(SK_PASTEARG,sk_argcount(__VA_ARGS__))


#define sk_classify(Class) \
    (void)(NO&&((void)[Class class],NO))



#if DEBUG
#define sk_keywordify autoreleasepool {}
#else
#define sk_keywordify try {} @catch (...) {}
#endif

#endif /* StreamMacros_h */
