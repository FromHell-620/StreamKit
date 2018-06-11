//
//  SKDisposable.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/9.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKDisposable : NSObject

@property (atomic,assign,getter=isDisposed,readonly) BOOL disposed;

- (instancetype)initWithBlock:(dispatch_block_t)block;

+ (instancetype)disposableWithBlock:(dispatch_block_t)block;

- (void)dispose;

- (SKDisposable *)asScopedDisposable;

@end
