//
//  TKExceptionGuard.m
//  ToolKit
//
//  Created by chunhui on 16/3/18.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKExceptionGuard.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"
#import "NSObject+signature.h"
#import "NSArray+adapter.h"
#import "NSCache+adapter.h"
#import "NSMutableArray+adapter.h"
#import "NSNull+forwardMethods.h"
#import "NSObject+forwardingTarget.h"
#import "NSMutableDictionary+adapter.h"
#import "NSNotificationCenter+adapter.h"

@implementation TKExceptionGuard

/**
 *  注册异常保护
 */
+(void)registerExceptionGuard
{

#ifndef DEBUG
    
//release才生效
    
    NSArray* arr = [NSArray array];
    NSMutableArray* mutableArr = [NSMutableArray array];
    NSMutableDictionary* mutableDic = [NSMutableDictionary dictionary];
    
    
    Class tmpI = objc_getClass(NSStringFromClass([arr class]).UTF8String);
    Class tmpM = objc_getClass(NSStringFromClass([mutableArr class]).UTF8String);
    Class tmpDM = objc_getClass(NSStringFromClass([mutableDic class]).UTF8String);
    
    [[NSObject class] jr_swizzleMethod:@selector(forwardingTargetForSelector:) withMethod:@selector(tk_myforwardingTargetForSelector:) error:nil];
    
    // [[NSObject class] jr_swizzleMethod:@selector(forwardInvocation:) withMethod:@selector(myForwardInvocation:) error:nil];
    
    [tmpI jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(tk_myObjectAtIndex:) error:nil];
    [[NSArray class] jr_swizzleClassMethod:@selector(arrayWithObjects:count:) withClassMethod:@selector(tk_myArrayWithObjects:count:) error:nil];
    [tmpM jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(tk_myMutableObjectAtIndex:) error:nil];
    [tmpM jr_swizzleMethod:@selector(addObject:) withMethod:@selector(tk_myAddObject:) error:nil];
    [tmpM jr_swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(tk_myInsertObject:atIndex:) error:nil];
    [tmpM jr_swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(tk_myRemoveObjectAtIndex:) error:nil];
    [tmpM jr_swizzleMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(tk_myReplaceObjectAtIndex:withObject:) error:nil];
    [tmpDM jr_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(tk_mySetObject:forKey:) error:nil];
    [[NSCache class] jr_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(tk_mySetObject:forKey:) error:nil];
    [[NSCache class] jr_swizzleMethod:@selector(setObject:forKey:cost:) withMethod:@selector(tk_mySetObject:forKey:cost:) error:nil];
    [[NSDictionary class] jr_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withClassMethod:@selector(tk_myDictionaryWithObjects:forKeys:count:) error:nil];
    
#endif
    
    //注册 observer 交换方法
     Class centerClass = [[NSNotificationCenter defaultCenter] class];
    [centerClass jr_swizzleMethod:@selector(addObserver:selector:name:object:) withMethod:@selector(tk_addObserver:selector:name:object:) error:nil];
    [centerClass jr_swizzleMethod:@selector(removeObserver:) withMethod:@selector(tk_removeObserver:) error:nil];
    [centerClass jr_swizzleMethod:@selector(removeObserver:name:object:) withMethod:@selector(tk_removeObserver:name:object:) error:nil];
    
}

@end
