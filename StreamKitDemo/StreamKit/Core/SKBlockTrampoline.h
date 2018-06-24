//
//  SKBlockTrampoline.h
//  StreamKitDemo
//
//  Created by 李浩 on 2018/6/18.
//  Copyright © 2018年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKBlockTrampoline : NSObject

+ (id)invokeBlock:(id)block arguments:(NSArray *)Arguments;

@end
