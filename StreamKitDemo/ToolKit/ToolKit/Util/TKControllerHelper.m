//
//  TKControllerHelper.m
//  ToolKit
//
//  Created by chunhui on 15/8/30.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import "TKControllerHelper.h"

@implementation TKControllerHelper

+(UIViewController *)ControllerWithName:(NSString *)name
{

    if (name.length == 0){
        return nil;
    }
    Class clazz = NSClassFromString(name);
    UIViewController *controller = [[clazz alloc]initWithNibName:name bundle:nil];
    
    return controller;
    
}

@end
