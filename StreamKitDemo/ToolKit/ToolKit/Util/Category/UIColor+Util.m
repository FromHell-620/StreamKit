//
//  UIColor+Util.m
//  ToolKit
//
//  Created by chunhui on 16/1/12.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)


+(UIColor *)colorWithHexString:(NSString *)hex
{
    NSString *value = nil;
    if ([hex hasPrefix:@"#"]) {
        value = [hex substringFromIndex:1];
    }else if ([hex hasPrefix:@"0x"] || [hex hasPrefix:@"0X"]){
        value = [hex substringFromIndex:2];
    }
    NSScanner *scanner = [[NSScanner alloc] initWithString:value];
    NSInteger r , g , b ;
    CGFloat a = 1.0;
    CGFloat base = 0xf;
    
    unsigned int hexInt ;
    [scanner scanHexInt:&hexInt];
    
    switch ([value length]) {
        case 3: // #RGB
            
            base = 0xf;
            a = base;
            r = hexInt >>8 & 0xf;
            g = hexInt >>4 & 0xf;
            b = hexInt & 0xf;
            
            break;
        case 4: // #ARGB
            
            base = 0xf;
            a = hexInt >> 12 & 0xf;
            r = hexInt >>8 & 0xf;
            g = hexInt >>4 & 0xf;
            b = hexInt & 0xf;
            
            break;
        case 6: // #RRGGBB
            
            base = 0xff;
            r = hexInt >> 16 & 0xff;
            g = hexInt >> 8  & 0xff;
            b = hexInt & 0xff;
            a = base;
            
            
            break;
        case 8: // #AARRGGBB
            
            base = 0xff;
            a = hexInt >> 24 & 0xff;
            r = hexInt >> 16 & 0xff;
            g = hexInt >> 8  & 0xff;
            b = hexInt & 0xff;
            
            
            break;
        default:
            return nil;
    }
    
    
    return [UIColor colorWithRed:r/base green:g/base blue:b/base alpha:a/base];
}

+(UIColor *)colorWithInteger:(NSInteger)color
{
    return [UIColor colorWithRed:(color>>16 & 0xff)/255.0 green:(color>>8 & 0xff)/255.0 blue:(color & 0xff)/255.0 alpha:1.0];
}

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*) colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (NSString *) hexFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

@end
