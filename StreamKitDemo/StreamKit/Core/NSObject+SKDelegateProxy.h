//
//  NSObject+SKDelegateProxy.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/30.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKDelegateProxy;

@interface NSObject (SKDelegateProxy)

@property (nonatomic,strong,readonly) SKDelegateProxy *sk_delegateProxy;

@end
