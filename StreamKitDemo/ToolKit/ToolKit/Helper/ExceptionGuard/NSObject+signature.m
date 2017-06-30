//
//  NSObject+signature.m
//  mapframework
//
//  Created by xing lion on 4/24/14.
//  Copyright (c) 2014 fangying. All rights reserved.
//

#import "NSObject+signature.h"
#import "TKSmartFunction.h"
#import <objc/runtime.h>



@implementation NSObject (signature)
@dynamic msgObj;


- (void)setMsgObj:(id)object {
    objc_setAssociatedObject(self, @selector(msgObj), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)msgObj {
    return objc_getAssociatedObject(self, @selector(msgObj));
}


- (id)tk_myforwardingTargetForSelector:(SEL)aSelector
{

    BOOL aBool =   [self respondsToSelector:aSelector];
    
    
   NSMethodSignature*  signatrue = [self methodSignatureForSelector:aSelector];
    
    if (aBool || signatrue) {
        
        return [self tk_myforwardingTargetForSelector:aSelector];
    }
    else
    {
    
        TKSmartFunction* func =  [[TKSmartFunction alloc] init];
        
        [func addFunc:aSelector];
        
        return func;
    }
    
}



//- (NSMethodSignature *)myMethodSignatureForSelector:(SEL)aSelector
//{
//
//    NSMethodSignature*  signatrue=   [self myMethodSignatureForSelector:aSelector];
//    
//    BOOL aBool =   [self respondsToSelector:aSelector];
//    
//    if (signatrue || aBool ) {
//    
//        return signatrue;
//    }
//    else
//    {
//    
//        BMSmartFunction* func =  [[BMSmartFunction alloc] init];
//        
//        [func addFunc:aSelector];
//        
//        [self setMsgObj:func];
//        
//        return [func methodSignatureForSelector:aSelector];
//    
//    }
//    
//}
//
//- (void)myForwardInvocation:(NSInvocation *)anInvocation
//{
//    
//    id func =[self msgObj];
//    if ( func) {
//        
//        [anInvocation setTarget:func];
//        
//        [anInvocation invoke];
//        
//        objc_removeAssociatedObjects(self);
//        
//    }
//    else
//    {
//    
//        [self myForwardInvocation:anInvocation];
//    
//    }
//}

@end
