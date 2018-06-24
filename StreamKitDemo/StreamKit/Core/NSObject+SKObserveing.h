//
//  NSObject+SKObserveing.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/24.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSignal;

@interface NSObject (SKObserveing)

- (SKSignal *)sk_observeWith

@end
