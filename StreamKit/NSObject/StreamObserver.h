//
//  StreamObserver.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/29.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreamObserver : NSObject

@property (nonatomic,unsafe_unretained,readonly) NSObject* object;

@property (nonatomic,readonly) id keyPath;

@property (nonatomic,readonly) id nilValue;

#ifdef DEBUG
@property (nonatomic,readonly,copy) NSString* name;
#endif

- (instancetype)initWithObject:(id)object nilValue:(id)nilValue;

- (instancetype)initWithObject:(id)object keyPath:(id)keyPath nilValue:(id)nilValue;

- (void)setObject:(StreamObserver*)object forKeyedSubscript:(NSString *)keyPath;

@end
