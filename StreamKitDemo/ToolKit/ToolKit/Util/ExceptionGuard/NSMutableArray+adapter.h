//
//  NSMutableArray+adapter.h
//  BaiduMapGeminiSDK
//
//  Created by xing lion on 13-9-27.
//  Copyright (c) 2013年 BaiduLBSMapClient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (adapter)

- (void)tk_myAddObject:(id)anObject;
- (id)tk_myMutableObjectAtIndex:(NSUInteger)index;
- (void)tk_myInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)tk_myRemoveObjectAtIndex:(NSUInteger)index;
- (void)tk_myReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end
