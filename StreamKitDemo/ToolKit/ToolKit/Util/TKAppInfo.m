//
//  TKSoftwareInfo.m
//  ToolKit
//
//  Created by chunhui on 15/9/11.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "TKAppInfo.h"

@implementation TKAppInfo

//+(void)load
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"version : %@",[TKAppInfo appVersion]);
//    });
//}

+(NSString *)appVersion
{
    NSDictionary *info = [[NSBundle mainBundle]infoDictionary];
    return info[@"CFBundleShortVersionString"];
}

+(NSString *)appName
{
    NSDictionary *info = [[NSBundle mainBundle]infoDictionary];
    NSString *name = info[@"CFBundleDisplayName"];
    if (name.length == 0) {
        name = info[@"CFBundleName"];
    }
    return name;
}

+(UIImage *)launchImage
{
    NSArray *launches = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UILaunchImages"];
    NSString *imageName = nil;
    
    if(launches){
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NSString * curSize = NSStringFromCGSize(screenSize);
        
        for (NSDictionary *dict in launches) {
            NSString *sizeStr = dict[@"UILaunchImageSize"];
            if ([curSize isEqualToString:sizeStr]) {
                imageName = dict[@"UILaunchImageName"];
                break;
            }
        }
    }
    
    if (imageName) {
        
        return  [UIImage imageNamed:imageName];
    }
    return nil;
}


+(UIImage *)appIcon
{
    /*
     CFBundleIcons =     {
     CFBundlePrimaryIcon =         {
     CFBundleIconFiles =             (
     AppIcon29x29,
     AppIcon40x40,
     AppIcon60x60
     );
     };
     };
     */
    
    NSArray *iconNames = @[@"AppIcon60x60" , @"AppIcon40x40" , @"AppIcon29x29"];
    
    UIImage *icon = nil;
    for (NSString *name in iconNames) {
        icon = [UIImage imageNamed:name];
        if (icon) {
            return icon;
        }
    }
    
    return nil;
    
}



@end
