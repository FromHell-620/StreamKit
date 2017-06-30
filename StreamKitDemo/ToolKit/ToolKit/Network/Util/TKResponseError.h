//
// Created by 凯伦 on 2016/12/26.
// Copyright (c) 2016 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TKResponseErrorType) {
    TKResponseErrorTypeNetwork = 0,    // 网络错误
    TKResponseErrorTypeStatusCode = 1, // Http状态码错误
    TKResponseErrorTypeJsonFormat = 2, // Json解析出错
    TKResponseErrorTypeErrorNo = 3,    // 服务器返回一个错误码，并且不为零
};

@interface TKResponseError : NSObject

@property(nonatomic) TKResponseErrorType type;
@property(nonatomic) int code;
@property(nonatomic, strong) NSString *msg;
@property(nonatomic, strong) NSError *error;
@property(nonatomic) BOOL isHandled;

+ (instancetype)errorWithType:(TKResponseErrorType)type code:(int)code msg:(NSString *)msg;

@end