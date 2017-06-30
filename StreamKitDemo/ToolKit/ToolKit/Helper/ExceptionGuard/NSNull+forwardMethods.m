//
//  NSNull+forwardMethods.m
//  ObjectTest
//
//  Created by biosli on 14-4-15.
//  Copyright (c) 2014年 biosli. All rights reserved.
//

#import "NSNull+forwardMethods.h"

static NSArray *sTmpOutput = nil;

@implementation NSNull (forwardMethods)

#ifndef DEBUG
//Note: 这个判断不要做，可能会改变原有逻辑。 by biosli 2014.4.15
//- (BOOL)respondsToSelector:(SEL)aSelector
//{
//    for (id tmpObj in sTmpOutput) {
//        if ([tmpObj respondsToSelector: aSelector]) {
//            return YES;
//        }
//    }
//    return NO;
//}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (sTmpOutput == nil) {
        sTmpOutput = @[@"", @0, @[], @{}];
    }
    
    for (id tmpObj in sTmpOutput) {
        if ([tmpObj respondsToSelector: aSelector]) {
            return tmpObj;
        }
    }
    
    return [super forwardingTargetForSelector: aSelector];
}
#endif

@end
