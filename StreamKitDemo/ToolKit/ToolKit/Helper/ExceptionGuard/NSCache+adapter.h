//
//  NSCache+adapter.h
//  BaiduMapGeminiSDK
//
//  Created by xing lion on 13-10-22.
//  Copyright (c) 2013年 BaiduLBSMapClient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCache (adapter)

- (void)tk_mySetObject:(id)obj forKey:(id)key; // 0 cost
- (void)tk_mySetObject:(id)obj forKey:(id)key cost:(NSUInteger)g;

@end
