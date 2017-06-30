//
//  TKCommonTools+Date.m
//  ToolKit
//
//  Created by DoubleHH on 15/10/23.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "TKCommonTools.h"
#import "NSDate+Category.h"

const int TKSecondsOfMinute = 60;
const int TKSecondsOfHour   = 3600;
const int TKSecondsOfDay    = 86400;

// 中国日期形式, 如: 2014年3月20日 20:00
NSString *const TKDateFormatChineseAll          = @"yyyy年MM月dd日 HH:mm";
// 中国日期形式, 如: 2014年3月20日
NSString *const TKDateFormatChineseYMD          = @"yyyy年MM月dd日";
// 中国日期形式, 如: 2014年3月
NSString *const TKDateFormatChineseYM          = @"yyyy年MM月";
// 中国日期形式, 如: 2014-3-20
NSString *const TKDateFormatChineseShortYMD     = @"yyyy-MM-dd";
// 中国日期形式, 如: 2014-3-20 20:00:00
NSString *const TKDateFormatChineseLongYMD     = @"yyyy-MM-dd HH:mm:ss";
// 中国日期形式, 如: 3月20日 20:00
NSString *const TKDateFormatChineseMDHM         = @"MM月dd日 HH:mm";
// 中国日期形式, 如: 3月20日
NSString *const TKDateFormatChineseMD           = @"MM月dd日";
// 显示时分, 12:30
NSString *const TKDateFormatHHMM                = @"HH:mm";
// 显示英文的日期格式, 2014/12/03 16:30
NSString *const TKDateFormatEnglishAll          = @"yyyy/MM/dd HH:mm";
// 显示英文的日期格式, Oct 03, 2014 (2014/10/03)
NSString *const TKDateFormatEnglishMedium1      = @"MMM dd, YYYY";
// 显示英文的日期格式, 12/03/2014
NSString *const TKDateFormatEnglishMedium2      = @"MM/dd/YYYY";

@implementation TKCommonTools (TKDate)

+ (NSDateFormatter *)sharedformater {
    static NSDateFormatter *sFormater;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sFormater = [[NSDateFormatter alloc] init];
    });
    return sFormater;
}

+ (NSString *)dateStringWithFormat:(NSString *)format date:(NSDate *)date {
    if (!format.length || !date) {
        return nil;
    }
    NSDateFormatter *formatter = [self sharedformater];
    NSString *str = nil;
    @synchronized (formatter) {
        [formatter setDateFormat:format];
        str = [formatter stringFromDate:date];
    }
    return str;
}

+ (NSString *)datestringWithFormat:(NSString *)format timeStamp:(NSTimeInterval)timeStamp {
    if (timeStamp < 0) {
        return nil;
    }
    NSDateFormatter *formatter = [self sharedformater];
    NSString *str = nil;
    @synchronized (formatter) {
        [formatter setDateFormat:format];
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeStamp];
        str = [formatter stringFromDate:date];
    }
    return str;
}

+ (NSDate *)dateWithFormat:(NSString *)format dateString:(NSString *)dateString {
    if (format.length == 0 || dateString.length == 0) {
        return nil;
    }
    NSDate *date = nil;
    NSDateFormatter *formatter = [self sharedformater];
    @synchronized (formatter) {
        formatter.dateFormat = format;
        date = [formatter dateFromString:dateString];
    }
    return date;
}

+ (NSString *)dateStringWithFormat:(NSString *)format dateStr:(NSString *)dateString
{
    NSString *dateStr = nil;
    if (!format || !dateString) {
        return dateStr;
    }
    
    NSTimeInterval timeInterval = dateString.doubleValue;
    if (timeInterval) {
        dateStr = [self datestringWithFormat:format timeStamp:timeInterval];
    }
    
    return dateStr;
}

+(NSString *)dateFormateForDate:(NSDate *)date hasShort:(BOOL)hasShort
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *component = [calender components: (NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents = [calender components:(NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay)  fromDate:now];
    
    if (hasShort) {
        if (nowComponents.year == component.year && nowComponents.month == component.month && nowComponents.day == component.day) {
            return [NSString stringWithFormat:@"%02ld:%02ld",component.hour,component.minute];
        }
    }
    return [NSString stringWithFormat:@"%04ld年%02ld月%02ld日",component.year,component.month,component.day];
}

+(NSString *)dateDescForDate:(NSDate *)date
{
    NSDate *now = [NSDate date];
    NSTimeInterval interval = [now timeIntervalSinceDate:date];
    NSString *des = nil;
    
    if (interval < 5*60) {
        des = @"刚刚";
    }else if (interval < 60*60){
        des = [NSString stringWithFormat:@"%d分钟前",(int)interval/60];;
    }else if (interval < 60*60 * 24){
        des = [NSString stringWithFormat:@"%ld小时前",(NSInteger)(interval/3600)];
    } else if (interval < 60 * 60 * 24 * 8){
        des = [NSString stringWithFormat:@"%ld天前", (NSInteger)(interval/(3600 * 24))];
    } else {
        if (![date isThisYear]) {
            des = [TKCommonTools dateStringWithFormat:@"yyyy-MM-dd" date:date];
        } else {
            des = [TKCommonTools dateStringWithFormat:@"MM-dd HH:mm" date:date];
        }
    }
    return des;
}

+(NSString *)dateDescForTimeInterval:(NSNumber *)number {
    
    NSString *descString = nil;
    if (number) {
        NSTimeInterval interval = number.doubleValue;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        descString = [TKCommonTools dateDescForDate:date];
    }
    return descString;
}

+(NSString *)dateDescForTimeStr:(NSString *)dateString
{
    NSString *descString = nil;
    NSTimeInterval interval = dateString.doubleValue;
    if (interval) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        descString = [TKCommonTools dateDescForDate:date];
    }
    return descString;
}

+ (NSString *)weekOfDate:(NSDate *)date
{
    return [self weekOfDate:date WithType:(TKDateTowWorldsLength)];
}

+ (NSString *)weekOfDate:(NSDate *)date WithType:(TKDateWeekContentType)weekType
{
    if (!date) {
        return nil;
    }
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | kCFCalendarUnitWeekday;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger weekday = comps.weekday;
    NSArray *weekArray;
    
    if (weekType == TKDateTowWorldsLength)
    {
        weekArray = [NSArray arrayWithObjects:@"",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    }
    else if (weekType == TKDateThreeWorldsLength)
    {
        weekArray = [NSArray arrayWithObjects:@"",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    }
    NSString *weekStr = weekArray[weekday];
    
    return weekStr;
}


+ (NSString *) getLastMonthFirstTimeInterval:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* adcomps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    adcomps.month -= 1;
    adcomps.day = 0;
    NSDate *newDate = [calendar dateFromComponents:adcomps];
    NSTimeInterval timeInterval = [newDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",timeInterval];
}

+ (NSString *) getNextMonthLastTimeInterval:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* adcomps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    adcomps.month += 1;
    NSDate *newDate = [calendar dateFromComponents:adcomps];
    NSRange daysRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:newDate];
    adcomps.day = daysRange.length;
    newDate = [calendar dateFromComponents:adcomps];
    NSTimeInterval timeInterval = [newDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",timeInterval];
}

@end

