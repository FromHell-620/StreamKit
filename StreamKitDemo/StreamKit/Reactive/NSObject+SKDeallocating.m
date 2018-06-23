//
//  NSObject+SKDeallocating.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/22.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "NSObject+SKDeallocating.h"
#import "SKCompoundDisposable.h"
#import "SKReplaySubject.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSMutableSet *swizzledClasses() {
    static NSMutableSet *classes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classes = [NSMutableSet set];
    });
    return classes;
}

static void swizzledDeallocIfNeed(Class cls) {
    NSMutableSet *classes = swizzledClasses();
    @synchronized (classes) {
        if (![classes containsObject:cls]) {
            SEL dealloc_sel = sel_registerName("dealloc");
            __block void(*origin_dealloc)(__unsafe_unretained id,SEL) = NULL;
            IMP new_imp = imp_implementationWithBlock(^(__unsafe_unretained id target) {
                SKCompoundDisposable *compounDisposable = objc_getAssociatedObject(target, @selector(deallocDisposable));
                [compounDisposable dispose];
                if (!origin_dealloc) {
                    struct objc_super super_objc = {
                        .receiver = target,
#if !defined(__cplusplus)  &&  !__OBJC2__
                        .class = hookClass,
#else
                        .super_class = class_getSuperclass(cls)
#endif
                    };
                    void (*msgSend)(struct objc_super *objc,SEL method) = (__typeof__(msgSend))objc_msgSendSuper;
                    msgSend(&super_objc,dealloc_sel);
                    return ;
                }
                origin_dealloc(target,dealloc_sel);
            });
            if (!class_addMethod(cls, dealloc_sel, new_imp, "v@")) {
                origin_dealloc = (__typeof__(origin_dealloc))method_setImplementation(class_getInstanceMethod(cls, dealloc_sel), new_imp);
            }
        }
        [classes addObject:cls];
    }
}

@implementation NSObject (SKDeallocating)

- (SKCompoundDisposable *)deallocDisposable {
    SKCompoundDisposable *dellocDisposable = objc_getAssociatedObject(self, _cmd);
    if (dellocDisposable) return dellocDisposable;
    swizzledDeallocIfNeed([self class]);
    dellocDisposable = [SKCompoundDisposable disposableWithBlock:nil];
    objc_setAssociatedObject(self, _cmd, dellocDisposable, OBJC_ASSOCIATION_RETAIN);
    return dellocDisposable;
}

- (SKSignal *)deallocSignal {
    SKReplaySubject *deallocSignal = objc_getAssociatedObject(self, _cmd);
    if (deallocSignal) return deallocSignal;
    deallocSignal = [SKReplaySubject subject];
    [self.deallocDisposable addDisposable:[SKDisposable disposableWithBlock:^{
        [deallocSignal sendCompleted];
    }]];
    objc_setAssociatedObject(self, _cmd, deallocSignal, OBJC_ASSOCIATION_RETAIN);
    return deallocSignal;
}

@end
