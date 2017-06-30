//
//  NSString+URL.m
//  CaiLianShe
//
//  Created by chunhui on 15/11/26.
//  Copyright © 2015年 chenny. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (Encode)

-(NSString *)urlEncodeString
{
    if (self.length == 0) {
        return nil;
    }
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

-(NSString *)base64Encode
{
        
    NSData* originData = [self dataUsingEncoding:NSASCIIStringEncoding];
    
    return  [originData base64EncodedStringWithOptions:0];
    
}

-(NSString *)base64Decode
{
    
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return  [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
}

-(NSURL *)encodeURL
{
    NSString *percentStr = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:percentStr];
}


@end
