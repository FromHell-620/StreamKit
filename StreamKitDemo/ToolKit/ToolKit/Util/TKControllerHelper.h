//
//  TKControllerHelper.h
//  ToolKit
//
//  Created by chunhui on 15/8/30.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#define TKController(name)  [TKControllerHelper ControllerWithName:name]

#define TKMakeController(clazz) clazz * controller = (clazz *)TKController(NSStringFromClass(clazz))

@interface TKControllerHelper : NSObject

+(UIViewController *)ControllerWithName:(NSString *)name;

@end
