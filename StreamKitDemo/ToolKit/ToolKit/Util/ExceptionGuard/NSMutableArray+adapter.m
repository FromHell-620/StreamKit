//
//  NSMutableArray+adapter.m
//  BaiduMapGeminiSDK
//
//  Created by xing lion on 13-9-27.
//  Copyright (c) 2013年 BaiduLBSMapClient. All rights reserved.
//

#import "NSMutableArray+adapter.h"
#import "NSObject+forwardingTarget.h"

@implementation NSMutableArray (adapter)

- (id)tk_myMutableObjectAtIndex:(NSUInteger)index
{
    
    if (self.count == 0) {
    
        TKNSObject* ob = [[TKNSObject alloc] init];
        [self addObject:ob];
    }
    
    if (index > self.count -1) {
        
        index = self.count -1;
    }    
    
    return [self tk_myMutableObjectAtIndex:index];
}


- (void)tk_myAddObject:(id)anObject
{
    
    if (anObject) {
 
        [self tk_myAddObject:anObject];
        
    }
    
}

- (void)tk_myInsertObject:(id)anObject atIndex:(NSUInteger)index
{
 
    if (anObject) {
        
        [self tk_myInsertObject:anObject atIndex:index];
        
    }
    
}

- (void)tk_myRemoveObjectAtIndex:(NSUInteger)index
{

    if (self.count == 0) {
        
        return;
    }
    
    if (index > self.count -1) {
        
        index = self.count -1;
    }
    
    [self tk_myRemoveObjectAtIndex:index];
    
}

- (void)tk_myReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{

    if (index > self.count -1) {
        
        return;
    }
    
    
    if (anObject == nil) {
        
        return;
    }
    
    
    [self tk_myReplaceObjectAtIndex:index withObject:anObject];
}

@end
