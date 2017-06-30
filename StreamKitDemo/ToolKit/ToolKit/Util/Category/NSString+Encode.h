//
//  NSString+URL.h
//  CaiLianShe
//
//  Created by chunhui on 15/11/26.
//  Copyright © 2015年 chenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encode)

-(NSString *)urlEncodeString;
-(NSString *)base64Encode;
-(NSString *)base64Decode;
/**
 *  编码后的url
 *
 *  @return
 */
-(NSURL *)encodeURL;

@end
