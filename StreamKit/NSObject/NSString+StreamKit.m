//
//  NSString+StreamKit.m
//  StreamKitDemo
//
//  Created by 李浩 on 2017/3/31.
//  Copyright © 2017年 李浩. All rights reserved.
//

#import "NSString+StreamKit.h"

@implementation NSString (StreamKit)

- (Class)sk_classify
{
    return NSClassFromString(self);
}

@end
