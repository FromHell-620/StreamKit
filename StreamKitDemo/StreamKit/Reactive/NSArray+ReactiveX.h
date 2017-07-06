//
//  NSArray+ReactiveX.h
//  StreamKitDemo
//
//  Created by 李浩 on 2017/5/8.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSubscriber.h"

@class SKSignal;
@interface NSArray (ReactiveX)<SKSubscriber>

- (SKSignal*)sk_enumSignal;

@end
