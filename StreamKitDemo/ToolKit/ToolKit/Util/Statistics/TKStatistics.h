//
//  TKStatistics.h
//  ToolKit
//
//  Created by chunhui on 16/4/10.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TKLogLevel) {
    TKLogLevelDebug = 0,
    TKLogLevelInfo  = 1,
    TKLogLevelError = 2,
};

typedef NS_ENUM(NSInteger, TKLogType) {
    TKLogTypeFile = 0,
    TKLogTypeInstant = 1,
};

@interface TKStatistics : NSObject
/**
 *  设备cuid
 */
@property(nonatomic , copy) NSString *cuid;

+(instancetype)sharedInstance;

+(NSInteger)statisticFileSize;

/*
 * 记录事件开始 同时记录到boss
 * @param: level 记录的等级 对于boss 无效
 * @param: key 事件的key
 * @param: args 参数
 */
-(void)logBeginWithLevel:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args;
/*
 * 记录开始事件开始
 * @param: level 记录的等级 对于boss 无效
 * @param: key 事件的key
 * @param: args 参数
 * @param: addToBoss 是否记录到boss
 */
-(void)logBeginWithLevel:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args  addToBoss:(BOOL)addToBoss;
/*
 * 记录事件结束 同时记录到boss
 * @param: level 记录的等级 对于boss 无效
 * @param: key 事件的key
 * @param: args 参数
 */
-(void)logEndWithLevel:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args;
/*
 * 记录事件结束
 * @param: level 记录的等级 对于boss 无效
 * @param: key 事件的key
 * @param: args 参数
 * @param: addToBoss 是否记录到boss
 */
-(void)logEndWithLevel:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args  addToBoss:(BOOL)addToBoss;
/*
 * 添加统计事件  同时添加到boss 非实时
 * @param: level 记录的等级  对于boss 无效
 * @param: key   事件的key
 * @param: param 事件参数
 */
-(void)log:(TKLogLevel)level key:(NSString *)key param:(NSDictionary *)param;

/*
 * 添加统计事件  同时添加到boss 非实时
 * @param: level 记录的等级  对于boss 无效
 * @param: key   事件的key
 * @param: args 事件参数
 */
-(void)log:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args;
/*
 * 添加统计事件
 * @param: level 记录的等级  对于boss 无效
 * @param: key   事件的key
 * @param: args 事件参数
 * @param: addToBoss 是否添加到boss
 * @param: type 是否是实时(针对boss)
 */
-(void)log:(TKLogLevel)level key:(NSString *)key args:(NSArray *)args type:(TKLogType)type;

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

/*
 * 清除当前筛选
 */
-(void)clearFilter;

/**
 *  当前的日志文件路径
 *
 *  @return 
 */
+(NSArray *)currentLogPaths;

/**
 *  当前正在写入的文件路径
 *
 *  @return
 */
-(NSString *)currentLogPath;

@end


#define TKStatDebug( _key , _args )  \
[[TKStatistics ShareInstance] log:TKLogLevelDebug key:_key args:_args] ; \
TK_LOG(@"add statictics debug \n key :%@  args: %@",_key,_args)

#define TKStatDebugp(_key , _param) \
[[TKStatistics ShareInstance] log:TKLogLevelDebug key:_key param:_param] ; \
TK_LOG(@"add statictics debug \n key :%@  param: %@",_key,_param)

#define TKStatInfo(_key , _args) \
[[TKStatistics ShareInstance] log:TKLogLevelInfo key:_key args:_args] ; \
TK_LOG(@"add statictics info \n key :%@  args: %@",_key,_args)

#define TKStatInfop(_key , _param) \
[[TKStatistics ShareInstance] log:TKLogLevelInfo key:_key param:_param] ; \
TK_LOG(@"add statictics info \n key :%@  args: %@",_key,_param)


#define TKStatError(_key , _args) \
[[TKStatistics ShareInstance] log:TKLogLevelError key:_key args:_args] ; \
TK_LOG(@"add statictics error \n key :%@  args: %@",_key,_args)

#define TKStatErrorp(_key , _param) \
[[TKStatistics ShareInstance] log:TKLogLevelError key:_key param:_param] ; \
TK_LOG(@"add statictics error \n key :%@  args: %@",_key,_param)
