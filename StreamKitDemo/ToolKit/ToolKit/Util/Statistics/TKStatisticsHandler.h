//
//  TKStatisticsHandler.h
//  ToolKit
//
//  Created by chunhui on 16/4/10.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKStatistics.h"

@interface TKStatisticsHandler : NSObject

/**
 *  设备cuid
 */
@property(nonatomic , copy) NSString *cuid;

/*
 * 初始化 handler 设置 thresHold为缓存文件的大小
 */
-(instancetype)initWithThreshold:(NSInteger)thresHold maxLogDuration:(NSTimeInterval)duration;
/*
 * 添加统计
 */
-(void)Log:(TKLogLevel)level key:(NSString *)key param:(NSDictionary *)param date:(NSDate *)date duration:(NSTimeInterval)duration;
-(void)Log:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args date:(NSDate *)date duration:(NSTimeInterval)duration;
/*
 * 获得某个目录下文件中的统计
 */
-(NSArray *)logItemsAtPath:(NSString *)path;
/*
 * 获得当前的所有统计
 * @param: level 统计的级别，为所有时 设置 -1
 * @param: date  筛选的日期，返回date之后的日志 ,所有时设置为 nil
 * @param: count 每次返回的数目
 */
-(NSArray *)logItemsWithFilterLevel:(TKLogLevel)level date:(NSDate *)date countlimit:(NSInteger)count;

/*
 * 获得上一页当前的所有统计
 * @param: level 统计的级别，为所有时 设置 -1
 * @param: date  筛选的日期，返回date之后的日志 ,所有时设置为 nil
 * @param: count 每次返回的数目
 */
-(NSArray *)preLogItemsWithFilterLevel:(TKLogLevel)level date:(NSDate *)date countlimit:(NSInteger)count;

/**
 *  当前正在写入的文件路径
 *
 *  @return
 */
-(NSString *)currentLogPath;

/*
 * 清除当前筛选
 */
-(void)clearFilter;
/*
 * 删除过期的缓存
 */
+(void)removeCache;

/**
 *  日志文件目录数组
 *
 *  @return
 */
+(NSArray *)currentLogPaths;

@end
