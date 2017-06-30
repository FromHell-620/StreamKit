//
//  NSString+ValidateFormat.m
//  ToolKit
//
//  Created by chunhui on 2016/8/27.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "NSString+ValidateFormat.h"

@implementation NSString (ValidateFormat)

- (BOOL)isValidateEmail
{
    if (self.length < 3) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(BOOL)isValidatePhoneNum
{
    if (self.length != 11) {
        return NO;
    }
    NSString *phoneRegex = @"^[0-9]{11}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

// 判定是正整数
- (BOOL)isPositivePureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    NSInteger val;
    BOOL isInterger = [scan scanInteger:&val];
    return isInterger && [scan isAtEnd] && (val >= 0);
}


@end
