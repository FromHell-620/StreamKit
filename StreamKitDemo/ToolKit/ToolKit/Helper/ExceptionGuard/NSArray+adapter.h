//
//  NSArray+adapter.h
//  test
//
//  Created by xing lion on 13-9-27.
//  Copyright (c) 2013年 xing lion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (adapter)

- (id)tk_myObjectAtIndex:(NSUInteger)index;

+ (instancetype)tk_myArrayWithObjects:(const id [])objects count:(NSUInteger)cnt;
@end
