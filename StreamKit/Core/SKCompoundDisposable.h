//
//  SKCompoundDisposable.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/9.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKDisposable.h"

@interface SKCompoundDisposable : SKDisposable

+ (instancetype)compoundDisposable;

+ (instancetype)disposableWithdisposes:(NSArray<SKDisposable *> *)disposes;

- (void)addDisposable:(SKDisposable *)disposable;

- (void)removeDisposable:(SKDisposable *)disposable;

@end
