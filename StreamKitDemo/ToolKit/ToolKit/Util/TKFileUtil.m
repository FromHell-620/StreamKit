//
//  TKFileUtil.m
//  TookKit
//
//  Created by chunhui on 15/6/1.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import "TKFileUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation TKFileUtil

+(NSInteger)fileSizeInDirectory:(NSString *)dir
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attr = [fm attributesOfItemAtPath:dir error:nil];
    NSInteger sum = 0;
    sum += [[attr objectForKey:NSFileSize] integerValue];
    
    if ([[attr objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]) {
        NSArray *files = [fm contentsOfDirectoryAtPath:dir error:nil];
        for (NSString *item in files) {
            sum += [self fileSizeInDirectory:[dir stringByAppendingPathComponent:item]];
        }
    }
    return sum;
}

+(NSString *)cachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+(NSString *)docPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+(NSString *)pathForDir:(NSString *)dir pathComponent:(NSString*)component
{
    if (dir.length == 0) {
        return nil;
    }
    return [dir stringByAppendingPathComponent:component];
}

+(void)removeFilesAtPath:(NSString *)path
{
    if (path.length > 0) {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:path error:nil];
    }
}

+(BOOL)fileExistAtPath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}

+ (NSString *)fileMD5:(NSString *)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if(!handle)
    {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while (!done)
    {
        NSData *fileData = [handle readDataOfLength:256];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if([fileData length] == 0)
            done = YES;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        digest[0], digest[1],
                        digest[2], digest[3],
                        digest[4], digest[5],
                        digest[6], digest[7],
                        digest[8], digest[9],
                        digest[10], digest[11],
                        digest[12], digest[13],
                        digest[14], digest[15]];
    return result;
}

@end
