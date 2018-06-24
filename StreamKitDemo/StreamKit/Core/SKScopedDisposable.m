//
//  SKScopedDisposable.m
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/11.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKScopedDisposable.h"

@implementation SKScopedDisposable

- (void)dealloc {
    [self dispose];
}

- (SKDisposable *)asScopedDisposable {
    return self;
}

@end
