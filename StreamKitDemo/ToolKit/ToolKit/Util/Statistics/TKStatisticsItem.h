//
//  TKStatisticsItem.h
//  ToolKit
//
//  Created by chunhui on 16/4/10.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKStatistics.h"


@interface TKStatisticsItem : NSObject

@property (nonatomic , readonly       ) NSInteger      logId;
@property (nonatomic , assign         ) TKLogLevel     level;
@property (nonatomic , assign         ) TKLogType      type;
@property (nonatomic , assign         ) NSInteger      dataType;
@property (nonatomic , copy           ) NSString       *key;
@property (nonatomic , strong         ) NSDictionary   *param;
@property (nonatomic , strong         ) NSArray        *args;
@property (nonatomic , strong         ) NSString       *cuid;
@property (nonatomic , assign         ) NSTimeInterval timeStamp;
@property (nonatomic , assign         ) NSTimeInterval duration;
@property (nonatomic , strong         ) NSString       *appVerison;
@property (nonatomic , strong,readonly) NSString       *json;


-(instancetype)initWithLevel:(TKLogLevel)level type:(TKLogType)type key:(NSString *)key param:(NSDictionary *)param args:(NSArray *)args;

+(TKStatisticsItem *)DeserializeFromContent:(NSString *)content;

@end
