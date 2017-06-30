//
//  NSNotificationCenter+adapter.m
//  ToolKit
//
//  Created by chunhui on 16/3/18.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "NSNotificationCenter+adapter.h"

@implementation NSNotificationCenter (adapter)

-(void)tk_addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSString *)aName object:(nullable id)anObject
{
    [self tk_addObserver:observer selector:aSelector name:aName object:anObject];
    //add for extra info
}

-(void)tk_removeObserver:(id)observer
{
    [self tk_removeObserver:observer];
    //add for extra info
}

-(void)tk_removeObserver:(id)observer name:(NSString *)aName object:(id)anObject
{
    [self tk_removeObserver:observer name:anObject object:anObject];
    //add for extra info
}

@end
