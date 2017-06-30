//
//  TKFileUtil.h
//  TookKit
//
//  Created by chunhui on 15/6/1.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKFileUtil : NSObject

+(NSInteger)fileSizeInDirectory:(NSString *)dir;

+(NSString *)cachePath;

+(NSString *)docPath;

+(void)removeFilesAtPath:(NSString *)path;

+(NSString *)pathForDir:(NSString *)dir pathComponent:(NSString*)component;

+(BOOL)fileExistAtPath:(NSString *)path;

+ (NSString *)fileMD5:(NSString *)filePath;

@end
