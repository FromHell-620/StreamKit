//
//  SKSerialDisposable.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/17.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKDisposable.h"

@interface SKSerialDisposable : SKDisposable

@property (atomic,strong) SKDisposable *disposable;

+ (instancetype)disposableWithDisposable:(SKDisposable *)disposable;

- (SKDisposable *)swapInDisposable:(SKDisposable *)disposable;

@end
