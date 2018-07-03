//
//  SKDelegatePoxy.h
//  StreamKitDemo
//
//  Created by imac on 2018/6/29.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSignal;

@interface SKDelegateProxy : NSObject

@property (nonatomic,unsafe_unretained) id realDelegate;

@property (nonatomic,strong,readonly) Protocol *protocol;

- (instancetype)initWithProtocol:(Protocol *)protocol;

@end
