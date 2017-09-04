//
//  NSNotificationCenter+ReactiveX.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/7/8.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSignal;

@interface NSNotificationCenter (ReactiveX)

- (SKSignal *)sk_signalWithName:(NSNotificationName)name object:(id)object;

@end
