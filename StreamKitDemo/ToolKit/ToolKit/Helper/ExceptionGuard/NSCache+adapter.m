//
//  NSCache+adapter.m
//  BaiduMapGeminiSDK
//
//  Created by xing lion on 13-10-22.
//  Copyright (c) 2013年 BaiduLBSMapClient. All rights reserved.
//

#import "NSCache+adapter.h"

@implementation NSCache (adapter)

- (void)tk_mySetObject:(id)obj forKey:(id)key
{
    if (obj && key) {
        [self tk_mySetObject:obj forKey:key];
    }

}

- (void)tk_mySetObject:(id)obj forKey:(id)key cost:(NSUInteger)g
{
    if (obj && key) {
        [self tk_mySetObject:obj forKey:key cost:g];
    }
    
}

@end
