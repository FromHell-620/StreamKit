//
//  NSObject+signature.h
//  mapframework
//
//  Created by xing lion on 4/24/14.
//  Copyright (c) 2014 fangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (signature)


@property(nonatomic,strong) id msgObj;

- (id)tk_myforwardingTargetForSelector:(SEL)aSelector;

//- (NSMethodSignature *)myMethodSignatureForSelector:(SEL)aSelector;
//
//- (void)myForwardInvocation:(NSInvocation *)anInvocation;

@end
