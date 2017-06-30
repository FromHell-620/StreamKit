//
//  TKSoftwareInfo.h
//  ToolKit
//
//  Created by chunhui on 15/9/11.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKAppInfo : NSObject

+(NSString *)appVersion;

+(NSString *)appName;

/**
 *  对应当前设备的启动页
 *
 */
+(UIImage *)launchImage;

/**
 *  app icon 从最大的开始返回
 *
 */
+(UIImage *)appIcon;

@end
