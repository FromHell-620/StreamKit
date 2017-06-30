//
//  TKStatistics.m
//  ToolKit
//
//  Created by chunhui on 16/4/10.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKStatistics.h"
#import "TKStatisticsHandler.h"
#import "TKStatisticsItem.h"

//#define kNetworkLatencyReportSampling 10

#define kLogFileSize  50*1024 //单个缓存文件大小
#define kLogDuration  24*60*60 //单个文件的保存时间，超过即需要上传

@interface TKStatistics()

@property(nonatomic , strong) TKStatisticsHandler *handler;
@property(nonatomic , assign) TKLogLevel  maskLogLevel;

@property(nonatomic , strong) NSMutableArray *durationLogs;

@end

@implementation TKStatistics

+(instancetype)sharedInstance
{
    static TKStatistics *statistics = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statistics = [[TKStatistics alloc]init];
    });
    return statistics;
}

+(NSInteger)statisticFileSize
{
    return kLogFileSize;
}

-(NSString *)currentLogPath
{
    return [_handler currentLogPath];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _handler = [[TKStatisticsHandler alloc]initWithThreshold:kLogFileSize maxLogDuration:kLogDuration];
        self.maskLogLevel = TKLogLevelDebug - 1;//TKLogLevelError + 1;
        self.durationLogs = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setCuid:(NSString *)cuid
{
    _cuid = [cuid copy];
    _handler.cuid = cuid;
}

/*
 * 添加统计
 */

-(void)logBeginWithLevel:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args
{

    TKStatisticsItem *item = [[TKStatisticsItem alloc]init];
    item.level = level;
    item.key   = key;
    item.args  = args;
    item.timeStamp = [NSDate  timeIntervalSinceReferenceDate];
    
    [self.durationLogs addObject:item];
    
}

-(void)logEndWithLevel:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args
{
    if (level > self.maskLogLevel) {
        TKStatisticsItem *item = nil;
        for (TKStatisticsItem* it in _durationLogs) {
            if ([it.key isEqualToString:key]) {
                item = it;
                break;
            }
        }
        if (item) {
            [_durationLogs removeObject:item];
            NSDate *date = [NSDate date];
            NSTimeInterval interval = [date timeIntervalSinceReferenceDate];
            [_handler Log:level key:key args:args date:date duration:(interval - item.timeStamp)];
        }
    }
}

-(void)log:(TKLogLevel)level key:(NSString *)key param:(NSDictionary *)param
{
    [self log:level key:key param:param type:TKLogTypeFile];
}


-(void)log:(TKLogLevel)level key:(NSString *)key param:(NSDictionary *)param type:(TKLogType)type
{
    if (level > self.maskLogLevel) {
        [_handler Log:level key:key param:param date:nil duration:0];
    }
}

-(void)log:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args
{
    [self log:level key:key args:args  type:TKLogTypeFile];
}
-(void)log:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args type:(TKLogType)type
{
    if (level > self.maskLogLevel) {
        [_handler Log:level key:key args:args date:nil duration:0];
    }
}

/*
 * 获得某个目录下文件中的统计
 */
-(NSArray *)logItemsAtPath:(NSString *)path
{
    return [_handler logItemsAtPath:path];
}
/*
 * 获得当前的所有统计
 * @param: level 统计的级别，为所有时 设置 -1
 * @param: date  筛选的日期，返回date之后的日志 ,所有时设置为 nil
 * @param: count 每次返回的数目
 */
-(NSArray *)logItemsWithFilterLevel:(TKLogLevel)level date:(NSDate *)date countlimit:(NSInteger)count
{
    return [_handler logItemsWithFilterLevel:level date:date countlimit:count];
}
/*
 * 获得上一页当前的所有统计
 * @param: level 统计的级别，为所有时 设置 -1
 * @param: date  筛选的日期，返回date之后的日志 ,所有时设置为 nil
 * @param: count 每次返回的数目
 */
-(NSArray *)preLogItemsWithFilterLevel:(TKLogLevel)level date:(NSDate *)date countlimit:(NSInteger)count
{
    return [_handler preLogItemsWithFilterLevel:level date:date countlimit:count];
}

/*
 * 清除当前筛选
 */
-(void)clearFilter
{
    [_handler clearFilter];
}

+(NSArray *)currentLogPaths
{
    return [TKStatisticsHandler currentLogPaths];
}

@end
