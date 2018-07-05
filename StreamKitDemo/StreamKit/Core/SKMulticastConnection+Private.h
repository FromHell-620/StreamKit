//
//  SKMulticastConection+Private.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/7/4.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import "SKMulticastConnection.h"

@class SKSignal;
@class SKSubject;

@interface SKMulticastConnection (Private)

- (instancetype)initWithSourceSignal:(SKSignal *)sourceSignal subject:(SKSubject *)subject;

@end
