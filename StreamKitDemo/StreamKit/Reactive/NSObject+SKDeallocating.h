//
//  NSObject+SKDeallocating.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/22.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKCompoundDisposable;
@class SKSignal;

@interface NSObject (SKDeallocating)

@property (nonatomic,strong,readonly) SKCompoundDisposable *deallocDisposable;

@property (nonatomic,strong,readonly) SKSignal *deallocSignal;

@end
