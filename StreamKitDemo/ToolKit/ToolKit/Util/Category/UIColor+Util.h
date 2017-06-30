//
//  UIColor+Util.h
//  ToolKit
//
//  Created by chunhui on 16/1/12.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define RGB(r,g,b)    RGBA(r,g,b,1)//[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//
//#define RGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//#define RGBACOLOR(r,g,b,a) RGBA(r,g,b,a)

//#define HexColor(color) [UIColor colorWithInteger:color]

@interface UIColor (Util)

+(UIColor *)colorWithInteger:(NSInteger)color;

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;

+(UIColor *)colorWithHexString:(NSString *)hex;

@end
