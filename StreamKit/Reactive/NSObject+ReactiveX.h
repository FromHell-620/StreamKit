//
//  NSObject+ReactiveX.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/4/7.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSignal;

@interface NSObject (ReactiveX)

- (SKSignal*)sk_ObserveForKeyPath:(NSString*)keypath;

@end
