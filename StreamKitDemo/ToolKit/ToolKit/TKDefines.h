//
//  TKDefines.h
//  ToolKit
//
//  Created by DoubleHH on 15/10/18.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#ifndef TKDefines_h
#define TKDefines_h

// Document Path
#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
// NSUserDefaults的系统单例
#define Defaults [NSUserDefaults standardUserDefaults]
// NSNotification
#define NotificationCenter [NSNotificationCenter defaultCenter]
// Null To Nil
#define NULL_TO_NIL(__objc) ((id)[NSNull null] == (__objc) ? nil : (__objc))
// Check is Dictionary
#define IsDictionaryClass(__obj) ((__obj) && [(__obj) isKindOfClass:[NSDictionary class]])
// Check is Array
#define IsArrayClass(__obj) ((__obj) && [(__obj) isKindOfClass:[NSArray class]])
// 把字符串首尾的空格和回车去掉
#define TrimStr(__str) [(__str) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (64.0f)

// tab栏高度
#define TAB_BAR_HEIGHT (48.0f)

// 屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// 屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

//判断屏幕
#define Is480Screen (SCREEN_HEIGHT == 480.0)     // iPhone4,4s
#define Is568Screen (SCREEN_HEIGHT == 568.0)     // iPhone5,5s
#define Is667Screen (SCREEN_HEIGHT == 667.0)     // 4.7, iPhone6
#define Is960Screen (SCREEN_HEIGHT == 736.0)     // 5.5, iPhone6+

// 判断设备
#define IsIphone4x  (SCREEN_HEIGHT == 480.0)     // iPhone4,4s
#define IsIphone5x  (SCREEN_HEIGHT == 568.0)     // iPhone5,5s
#define IsIphone6x  (SCREEN_HEIGHT == 667.0)     // 4.7, iPhone6
#define IsIphone6px (SCREEN_HEIGHT == 736.0)     // 5.5, iPhone6p+

//系统
#define OSV   [[[UIDevice currentDevice] systemVersion] floatValue]

// Color
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HexColor(color) [UIColor colorWithRed:((color)>>16 & 0xff)/255.0 green:((color) >> 8 & 0xff)/255.0 blue:((color) & 0xff)/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a) RGBA(r,g,b,a)

//sigleton
#undef	DEF_SINGLETON
#define DEF_SINGLETON \
+ (instancetype)sharedInstance;

#undef	IMP_SINGLETON
#define IMP_SINGLETON \
+ (instancetype)sharedInstance \
{ \
static dispatch_once_t once; \
static id __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}


#endif /* TKDefines_h */
