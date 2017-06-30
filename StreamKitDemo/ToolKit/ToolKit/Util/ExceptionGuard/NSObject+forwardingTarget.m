//
//  NSObject+forwardingTarget.m
//  mapframework
//
//  Created by xing lion on 14-4-8.
//  Copyright (c) 2014年 fangying. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>

#import "NSObject+forwardingTarget.h"
#import "TKSmartFunction.h"

@implementation TKNSObject

- (id)forwardingTargetForSelector:(SEL)aSelector
{

    TKSmartFunction* function =  [[TKSmartFunction alloc] init];
    
    BOOL  aBool =[function addFunc:aSelector];
    
    if (aBool) {
        
// don't del it !
        
        printf("###  =====XINGJIAN WORING====== PAY ATTENTION YOU CODE IS WRONG YOU MUST CHECK IT #### %s\n", [NSStringFromSelector(aSelector) cStringUsingEncoding: NSUTF8StringEncoding]);
        
        return function;
    }
    else
    {
        return [super forwardingTargetForSelector:aSelector];
        
    }

}

@end
