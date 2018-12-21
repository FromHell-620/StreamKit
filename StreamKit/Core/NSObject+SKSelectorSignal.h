//
//  NSObject+SKSelectorSignal.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/24.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSignal;

@interface NSObject (SKSelectorSignal)

- (SKSignal *)sk_signalForSelector:(SEL)selector;

- (SKSignal *)sk_signalForSelector:(SEL)selector protocol:(Protocol *)protocol;

@end
