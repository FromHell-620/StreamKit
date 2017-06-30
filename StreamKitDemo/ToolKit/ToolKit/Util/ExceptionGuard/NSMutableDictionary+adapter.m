//
//  NSMutableDictionary+adapter.m
//  BaiduMapGeminiSDK
//
//  Created by xing lion on 13-9-27.
//  Copyright (c) 2013年 BaiduLBSMapClient. All rights reserved.
//

#import "NSMutableDictionary+adapter.h"

@implementation NSDictionary(adapter)

+ (instancetype)tk_myDictionaryWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt
{
    
    for (int i = 0; i < cnt; i++) {
        
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        
        if (tmpItem == nil ||  tmpKey == nil) {
            return  nil;
        }
        
    }

    
   return  [self tk_myDictionaryWithObjects:objects forKeys:keys count:cnt];
    
}

@end


@implementation NSMutableDictionary (adapter)


- (void)tk_mySetObject:(id)anObject forKey:(id <NSCopying>)aKey
{

    if (anObject && aKey) {
        
        [self tk_mySetObject:anObject forKey:aKey];
        
    }
}


@end
