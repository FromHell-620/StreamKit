//
//  BMSmartFunction.m
//  objc_test
//
//  Created by xing lion on 14-4-7.
//  Copyright (c) 2014年 lion xing. All rights reserved.
//


#import <objc/message.h>
#import <objc/runtime.h>
#import "TKSmartFunction.h"


int smartFunction(id sel,SEL fun,...)
{
    return 0;
}

@implementation TKSmartFunction


-(void)dealloc
{


}

-(BOOL) addFunc:(SEL) sel
{
    NSString* selName = NSStringFromSelector(sel);
    
    NSMutableString* tmpString = [[NSMutableString alloc] initWithFormat:@"%@",selName];
    
   NSUInteger count = [tmpString replaceOccurrencesOfString:@":" withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0,selName.length)];
    
    NSMutableString* val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i  = 0; i < count; i++) {
        
        [val appendString:@"@"];
    }
    
    const char* varChar =  [val UTF8String];
    
   return  class_addMethod([TKSmartFunction class], sel, (IMP)smartFunction, varChar);
}

@end




