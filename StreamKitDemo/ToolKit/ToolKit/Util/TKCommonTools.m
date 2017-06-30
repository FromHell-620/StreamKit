//
//  TKCommonTools.m
//  ToolKit
//
//  Created by DoubleHH on 15/10/23.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "TKCommonTools.h"

inline void tk_safe_dispatch_sync_main_queue(void (^block)(void)) {
    if (!block) return;
    if ([[NSThread currentThread] isMainThread]) return block();
    dispatch_sync(dispatch_get_main_queue(), ^{ block(); });
}

@implementation TKCommonTools

+ (UILabel *)templateLabelWithFont:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (UILabel *)templateLabelWithFont:(UIFont *)font color:(UIColor *)color text:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    [label sizeToFit];
    return label;
}

+ (UIImage *)stretchableImageWithName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    if (image) {
        return [image stretchableImageWithLeftCapWidth:ceil(image.size.width * .5) topCapHeight:ceil(image.size.height * .5)];
    }
    return nil;
}

+ (NSString *)fomatString1ValueWithFloat:(CGFloat)floatValue {
    NSString *str = [NSString stringWithFormat:@"%.1f", floatValue];
    if ([str hasSuffix:@".0"]) {
        str = [NSString stringWithFormat:@"%.0f", floatValue];
    }
    return str;
}

+ (NSString *)fomatString2ValueWithFloat:(CGFloat)floatValue {
    NSString *str = [NSString stringWithFormat:@"%.2f", floatValue];
    if ([str hasSuffix:@"0"]) {
        str = [NSString stringWithFormat:@"%.1f", floatValue];
    } else {
        return str;
    }
    if ([str hasSuffix:@".0"]) {
        str = [NSString stringWithFormat:@"%.0f", floatValue];
    }
    return str;
}

/**
 *  随机uuid
 *
 *  @return
 */
+ (NSString *)uuid
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    
    return result;
}

//+ (NSString *)weekOfDate:(NSDate *)date{
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | kCFCalendarUnitWeekday;
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
//    NSInteger weekday = comps.weekday;
//    
//    NSString *weekStr = @"周日";
//    switch (weekday)
//    {
//        case 1:
//            weekStr = @"周日";
//            break;
//        case 2:
//            weekStr = @"周一";
//            break;
//        case 3:
//            weekStr = @"周二";
//            break;
//        case 4:
//            weekStr = @"周三";
//            break;
//        case 5:
//            weekStr = @"周四";
//            break;
//        case 6:
//            weekStr = @"周五";
//            break;
//        case 7:
//            weekStr = @"周六";
//            break;
//    }
//    
//    return weekStr;
//}
//
//+ (NSString *) getLastMonthFirstTimeInterval:(NSDate *)date
//{
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents* adcomps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
//    adcomps.month -= 1;
//    adcomps.day = 0;
//    NSDate *newDate = [calendar dateFromComponents:adcomps];
//    NSTimeInterval timeInterval = [newDate timeIntervalSince1970];
//    return [NSString stringWithFormat:@"%f",timeInterval];
//}
//
//+ (NSString *) getNextMonthLastTimeInterval:(NSDate *)date
//{
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents* adcomps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
//    adcomps.month += 1;
//    NSDate *newDate = [calendar dateFromComponents:adcomps];
//    NSRange daysRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:newDate];
//    adcomps.day = daysRange.length;
//    newDate = [calendar dateFromComponents:adcomps];
//    NSTimeInterval timeInterval = [newDate timeIntervalSince1970];
//    return [NSString stringWithFormat:@"%f",timeInterval];
//}

@end
