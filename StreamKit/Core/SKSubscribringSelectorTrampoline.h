//
//  SKSubscribringSelectorTrampoline.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/12/2.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSignal;

@interface SKSubscribringSelectorTrampoline : NSObject

@property (nonatomic,weak,readonly) NSObject* target;

@property (nonatomic,readonly) id keyPath;

- (instancetype)initWithTarget:(id)target;

- (void)setObject:(SKSignal*)object forKeyedSubscript:(NSString *)keyPath;

@end
