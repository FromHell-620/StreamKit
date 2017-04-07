//
//  StreamObserver.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/29.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSignal;

@interface StreamObserver : NSObject

@property (nonatomic,unsafe_unretained,readonly) NSObject* object;

@property (nonatomic,readonly) id keyPath;

@property (nonatomic,readonly) id nilValue;

- (instancetype)initWithObject:(id)object nilValue:(id)nilValue;

- (void)setObject:(SKSignal*)object forKeyedSubscript:(NSString *)keyPath;

@end
