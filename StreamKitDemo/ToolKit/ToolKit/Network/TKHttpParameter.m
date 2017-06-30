//
//  TKHttpParameter.m
//  ToolKit
//
//  Created by chunhui on 15/6/25.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import "TKHttpParameter.h"
#import "NSString+MD5.h"

@interface TKHttpParameter ()

@property(nonatomic , strong) NSMutableDictionary *param;

@end

@implementation TKHttpParameter

-(instancetype)init
{
    self = [super init];
    if (self) {
        _param = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)addValue:(id)value forKey:(NSString *)key
{
    NSAssert(key.length > 0 && value, @"add key must not empty value must not null");
    [_param setObject:[NSString stringWithFormat:@"%@",value] forKey:key];
}

-(void)addKeyValueDict:(NSDictionary *)dict
{
    if (dict) {
        [_param addEntriesFromDictionary:dict];
    }
}

-(NSDictionary *)build
{
//    [_param setObject:@"iOS" forKey:@"os"];
//    if ([_param objectForKey:@"uid"] == nil) {
//        NSString *myUid = MYUID;
//                
//        if(myUid.length >0){
//            [_param setObject:myUid forKey:@"uid"];
//        }
//    }
//    
//    if ([_param objectForKey:@"token"] == nil) {
//        NSString *token = [[[TKAccountManager SharedInstance] account] token];
//        
//        if (token) {
//            [_param setObject:token forKey:@"token"];
//        }
//    }
    
    NSString *sign = nil;
    if (self.codeSignBlock) {
        sign = self.codeSignBlock(_param);
    }else{
        sign = [self codeSign:_param];
    }
    if (sign.length > 0) {
        [_param setObject:sign forKey:@"sign"];
    }
    
    return [NSDictionary dictionaryWithDictionary:_param];
}

-(NSString *)codeSign:(NSDictionary *)dic
{
    NSMutableArray *realKeys = [[NSMutableArray alloc]initWithCapacity:[dic count]];
    // 删除这里的key是由于签名的时候，文件类型不用签名
    for (NSString *key in [dic allKeys]) {
        id value = [dic objectForKey:key];
        if (![value isKindOfClass:[NSData class]]) {
            [realKeys addObject:key];
        }
    }
    NSArray *myary = [realKeys sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
        return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableString *keyValue = [[NSMutableString alloc]init];
    
    for (NSString *key in myary)
    {
        [keyValue appendString: key];
        [keyValue appendString: @"="];
        [keyValue appendString: [NSString stringWithFormat:@"%@",dic[key]]];
        [keyValue appendString: @"&"];
    }
    
    if (keyValue.length != 0)
    {
        [keyValue deleteCharactersInRange:NSMakeRange(keyValue.length -1 , 1)];
    }
    NSString *sha1 = [keyValue sha1String];
    NSString *sign = [sha1 md5String];
    
    return sign;
}

@end
