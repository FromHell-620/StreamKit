//
//  NSObject+SKSelectorSignal.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/24.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "NSObject+SKSelectorSignal.h"
#import <objc/runtime.h>
#import "SKSubject.h"
#import "NSObject+SKDeallocating.h"
#import "SKCompoundDisposable.h"

static NSString *const SKSignalForSelectorAliasPrefix = @"sk_alias_";

static NSMutableSet *swizzleClasses() {
    static NSMutableSet *set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableSet set];
    });
    return set;
}

static BOOL ForwardInvocation(NSInvocation *invocation) {
    return YES;
}

static void SKSwizzleDelegateMethod(Class cls) {
    static NSMutableSet *deleteClasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deleteClasses = [NSMutableSet set];
    });
}

static void SKSwizzleForwardInvocation(Class cls) {
    SEL invocationSel = sel_registerName("forwardInvocation:");
    Method invocationMethod = class_getInstanceMethod(cls, invocationSel);
    void (*originInvocation)(__unsafe_unretained id,SEL,NSInvocation *) = NULL;
    IMP newInvocation = imp_implementationWithBlock(^ (__unsafe_unretained id self,SEL sel,NSInvocation *invocation) {
        BOOL math = ForwardInvocation(invocation);
        if (math) return ;
        if (originInvocation == NULL) {
            [self doesNotRecognizeSelector:invocationSel];
        }else {
            originInvocation(self,sel,invocation);
        }
    });
    if (!class_addMethod(cls, invocationSel, newInvocation, method_getTypeEncoding(invocationMethod))) {
        originInvocation = (__typeof__(originInvocation))method_getImplementation(invocationMethod);
        originInvocation = (__typeof__(originInvocation))method_setImplementation(invocationMethod, newInvocation);
    }
}

static void SKSwizzleClass(Class cls) {
    NSMutableSet *classes = swizzleClasses();
    @synchronized (classes) {
        if (![classes containsObject:cls]) {
            SKSwizzleForwardInvocation(cls);
            [classes addObject:cls];
        }
    }
}

static SEL SKAliasSelectorWithSelector(SEL sel) {
    NSString *alias_name = [[NSString alloc] initWithUTF8String:sel_getName(sel)];
    NSCParameterAssert(alias_name);
    return sel_registerName([SKSignalForSelectorAliasPrefix stringByAppendingString:alias_name].UTF8String);
}

@implementation NSObject (SKSelectorSignal)

//- (SKSignal *)sk_signalForSelector:(SEL)selector protocol:(Protocol *)protocol isDelegate:(BOOL)isDelegate{
//    SEL aliasSeletor = SKAliasSelectorWithSelector(selector);
//    @synchronized (self) {
//        SKSubject *subject = objc_getAssociatedObject(self, aliasSeletor);
//        if (subject) return subject;
//        SKSwizzleClass(object_getClass(self));
//        subject = [SKSubject subject];
//        objc_setAssociatedObject(self, aliasSeletor, subject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        [self.deallocDisposable addDisposable:[SKDisposable disposableWithBlock:^{
//            [subject sendCompleted];
//        }]];
//        
//        Method targetMethod = class_getInstanceMethod(object_getClass(self), selector);
//        if (targetMethod == NULL) {
//            if (protocol) {
//                struct objc_method_description desc = protocol_getMethodDescription(protocol, selector, YES, YES);
//                if (desc.name == NULL) {
//                    desc = protocol_getMethodDescription(protocol, selector, NO, YES);
//                }
//            }
//            if (isDelegate) {
//                <#statements#>
//            }
//        }
//    }
//}

@end
