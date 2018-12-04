//
//  NSInvocation+SKValues.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/30.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (SKValues)

@property (nonatomic,copy,readonly) NSArray *sk_values;

- (id)sk_argmentWithIndex:(NSInteger)index;

- (void)sk_setArgmentWithValue:(id)value atIndex:(NSInteger)index;

@end
