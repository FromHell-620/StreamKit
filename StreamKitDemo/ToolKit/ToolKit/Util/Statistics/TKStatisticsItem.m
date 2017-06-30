//
//  TKStatisticsItem.m
//  ToolKit
//
//  Created by chunhui on 16/4/10.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKStatisticsItem.h"

@interface TKStatisticsItem()

@property(nonatomic , assign) NSInteger logId;
@property(nonatomic , strong) NSString *json;

@end


@implementation TKStatisticsItem

-(instancetype)initWithLevel:(TKLogLevel)level type:(TKLogType)type key:(NSString *)key param:(NSDictionary *)param args:(NSArray *)args
{
    self = [super init];
    if (self) {
        self.level = level;
        self.type  = type;
        self.key   = key;
        self.param = param;
        self.args  = args;
        self.timeStamp = [[NSDate date] timeIntervalSinceReferenceDate];
        
    }
    return self;
    
}

+(TKStatisticsItem *)DeserializeFromContent:(NSString *)content
{
    /*
     * id | level | key | param | 时间戳 | duration | app version
     */
    
    NSArray *comps = [content componentsSeparatedByString:@"|"];
    
    if ([comps count] != 7){
        return nil;
    }
    
    TKStatisticsItem *item = [[TKStatisticsItem alloc]init];
    TKLogLevel level = TKLogLevelDebug;
    item.logId = [comps[0] integerValue];
    
    NSString *strLevel = comps[1];
    if ([strLevel isEqualToString:@"I"]) {
        level = TKLogLevelInfo;
    }else if ([strLevel isEqualToString:@"E"]){
        level = TKLogLevelError;
    }
    item.level = level;
    item.key = comps[2];
    
    NSString *json = comps[3];
    if (json.length > 0) {
        
        item.json = json;
        
        @try {
            NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if ([obj isKindOfClass:[NSArray class]]) {
                item.args = obj;
            }else if([obj isKindOfClass:[NSDictionary class]]){
                item.param = obj;
            }
        }
        @catch (NSException *exception) {
            
        }
    }
    
    NSString *strTimeStamp = comps[4];
    item.timeStamp = [strTimeStamp doubleValue];
    
    NSString *duration = comps[5];
    if (duration.length > 0) {
        item.duration = [duration integerValue];
    }
    item.appVerison = [comps[6] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSLog(@"item version is: %@",item.appVerison);
    
    return item;
}

@end
