//
//  SKMulticastConection.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/7/4.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSignal;
@class SKDisposable;

@interface SKMulticastConnection : NSObject

@property (nonatomic,strong,readonly) SKSignal *signal;

- (SKDisposable *)connect;

- (SKSignal *)autoConnect;

@end
