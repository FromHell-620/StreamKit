//
//  NSMutableDictionary+adapter.h
//  BaiduMapGeminiSDK
//
//  Created by xing lion on 13-9-27.
//  Copyright (c) 2013年 BaiduLBSMapClient. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (adapter)

+ (instancetype)tk_myDictionaryWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt;

@end


@interface NSMutableDictionary (adapter)


- (void)tk_mySetObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end
