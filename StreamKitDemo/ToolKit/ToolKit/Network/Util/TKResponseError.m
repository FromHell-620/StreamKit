//
// Created by 凯伦 on 2016/12/26.
// Copyright (c) 2016 chunhui. All rights reserved.
//

#import "TKResponseError.h"


@implementation TKResponseError {

}

+ (instancetype)errorWithType:(TKResponseErrorType)type code:(int)code msg:(NSString *)msg {
    TKResponseError *e = [[TKResponseError alloc] init];
    e.type = type;
    e.code = code;
    e.msg = msg;
    return e;
}

@end