//
//  NSNotificationCenter+ReactiveX.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/7/8.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSignal;

@interface NSNotificationCenter (SKSignalSupport)

- (SKSignal *)sk_signalWithName:(NSNotificationName)name object:(id)object;

- (SKSignal *)sk_signalWithName:(NSNotificationName)name object:(id)object observer:(id)observer;

@end
