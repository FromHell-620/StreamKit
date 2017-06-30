//
//  CHKeychain.h
//  CaiLianShe
//
//  Created by Chenny on 15/8/11.
//  Copyright (c) 2015年 chenny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h> 

@interface CHKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
