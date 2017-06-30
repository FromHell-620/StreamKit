//
//  TKHttpParameter.h
//  ToolKit
//
//  Created by chunhui on 15/6/25.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKHttpParameter : NSObject

@property(nonatomic , copy) NSString * (^codeSignBlock)(NSDictionary *param);

-(void)addValue:(id)value forKey:(NSString *)key;
-(void)addKeyValueDict:(NSDictionary *)dict;
-(NSDictionary *)build;

@end
