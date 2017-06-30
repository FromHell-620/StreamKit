//
//  NSArray+adapter.m
//  test
//
//  Created by xing lion on 13-9-27.
//  Copyright (c) 2013年 xing lion. All rights reserved.
//

#import "NSArray+adapter.h"

@implementation NSArray (adapter)


- (id)tk_myObjectAtIndex:(NSUInteger)index
{
    if (self.count == 0) {
        return nil;
    }
    if (index >= self.count) {
        return nil;
    }
    return [self tk_myObjectAtIndex:index];
}


+ (instancetype)tk_myArrayWithObjects:(const id [])objects count:(NSUInteger)cnt
{

    for (int i = 0 ; i < cnt; i++) {
        
        id objc =  objects[i];
        if (objc == nil) {
            return nil;
        }
    }
    
   return  [self tk_myArrayWithObjects:objects count:cnt];

}

@end
