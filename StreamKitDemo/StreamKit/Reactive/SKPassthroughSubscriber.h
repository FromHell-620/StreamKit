//
//  SKPassthroughSubscriber.h
//  StreamKitDemo
//
//  Created by imac on 2018/6/19.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSubscriber.h"

@class SKCompoundDisposable;

@interface SKPassthroughSubscriber : NSObject<SKSubscriber>

- (instancetype)initWithSubscriber:(id<SKSubscriber>)subscriber disposable:(SKCompoundDisposable *)disposable;

@end
