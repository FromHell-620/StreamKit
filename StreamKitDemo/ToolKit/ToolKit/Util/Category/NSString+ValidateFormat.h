//
//  NSString+ValidateFormat.h
//  ToolKit
//
//  Created by chunhui on 2016/8/27.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ValidateFormat)

- (BOOL)isValidateEmail;
-(BOOL)isValidatePhoneNum;
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string;
- (BOOL)isPositivePureInt:(NSString*)string;

@end
