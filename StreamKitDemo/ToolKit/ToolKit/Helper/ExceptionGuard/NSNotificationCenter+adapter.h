//
//  NSNotificationCenter+adapter.h
//  ToolKit
//
//  Created by chunhui on 16/3/18.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (adapter)

-(void)tk_addObserver:(nonnull id)observer selector:(nonnull SEL)aSelector name:(nullable NSString *)aName object:(nullable id)anObject;

-(void)tk_removeObserver:(nullable id)observer;

-(void)tk_removeObserver:(nullable id)observer name:(nonnull NSString *)aName object:(nullable id)anObject;

@end
