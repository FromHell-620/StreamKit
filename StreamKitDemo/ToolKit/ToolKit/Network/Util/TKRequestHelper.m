//
// Created by 凯伦 on 2016/12/28.
// Copyright (c) 2016 chunhui. All rights reserved.
//

#import "TKRequestHelper.h"
#import "MBProgressHUD.h"
#import "TKResponseError.h"
#import "TKNetworkManager.h"
#import "TKRequestHandler.h"


@implementation TKRequestHelper {

}

+(TKRequestHelper *)sharedInstance
{
    static TKRequestHelper *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[TKRequestHelper alloc]init];
    });
    return handler;
}

/**
 * 功能同[FATools showToast:]
 * @param msg
 */
- (void)showToast:(NSString *)msg {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!window) {
        window = [[[UIApplication sharedApplication] windows] firstObject];
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];

    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.label.numberOfLines = 0;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;

    [hud hideAnimated:true afterDelay:1];
}

/**
 * 缺省的处理Response错误的方法
 * 如果不想让这个方法处理错误，只需要设置error.isHandled = YES即可！
 * @param error
 */
- (void)handleResponseError:(TKResponseError *)error
                     failed:(void (^)(TKResponseError *error))failed
                   finished:(void (^)())finished {
    if (failed != nil) {
        failed(error);
    }

    if (!error.isHandled) {
        switch (error.type) {
            case TKResponseErrorTypeNetwork:
                NSLog(@"无法连接到服务器：%@", error.error.description);
                [self showToast:@"无法连接到服务器，请稍候重试"];
                break;

            case TKResponseErrorTypeStatusCode:
                NSLog(@"服务器异常：%d", error.code);
                [self showToast:@"服务器异常，请稍候重试"];
                break;

            case TKResponseErrorTypeJsonFormat:
                NSLog(@"解析Json出错：%@", error.msg);
                [self showToast:@"数据异常，请稍候重试"];
                break;

            case TKResponseErrorTypeErrorNo:
                NSLog(@"服务器异常：%d", error.code);

                if ([error.msg length]) {
                    [self showToast:error.msg];
                } else {
                    [self showToast:[NSString stringWithFormat:@"系统错误：%d", error.code]];
                }
                break;
        }
    }

    if (finished != nil) {
        finished();
    }
}

/**
 * 处理TKNetworkManager的failure错误的回调
 *
 * @param operation
 * @param error
 * @param failed
 * @param finished
 */
- (void)handleFailure:(NSURLSessionDataTask *)operation
                error:(NSError *)error
               failed:(void (^)(TKResponseError *error))failed
             finished:(void (^)())finished {

    NSHTTPURLResponse *response = (NSHTTPURLResponse *) operation.response;

    if (response.statusCode != 0) {
        // statusCode非零，那么就是4xx或者5xx这种状态码
        TKResponseError *e = [TKResponseError
                errorWithType:TKResponseErrorTypeStatusCode
                         code:response.statusCode
                          msg:@""];
        [self handleResponseError:e failed:failed finished:finished];

    } else {

        TKResponseError *e = [TKResponseError
                errorWithType:TKResponseErrorTypeNetwork
                         code:0
                          msg:@""];
        e.error = error;
        [self handleResponseError:e failed:failed finished:finished];
    }
}

#pragma mark - Simple Json

- (void)handleSuccessForSimpleJson:(NSURLSessionDataTask *)operation
                    responseObject:(id)responseObject
                           succeed:(nullable void (^)())succeed
                            failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                          finished:(nullable void (^)())finished {
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        @try {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        } @catch (NSException *exception) {
            responseObject = nil;
        }
    }

    // 解析Json出错
    if (responseObject == nil) {
        TKResponseError *e = [TKResponseError
                errorWithType:TKResponseErrorTypeJsonFormat
                         code:0
                          msg:@"JsonFormat Error: response cant convert to Dictionary"];
        e.error = error;
        [self handleResponseError:e failed:failed finished:finished];
        return;
    }

    // 错误码错误
    NSInteger errNo = [responseObject[@"errno"] integerValue];
    if (errNo != 0) {
        TKResponseError *e = [TKResponseError
                errorWithType:TKResponseErrorTypeErrorNo
                         code:errNo
                          msg:[responseObject[@"errmsg"] description]];
        [self handleResponseError:e failed:failed finished:finished];
        return;
    }

    if (succeed != nil) {
        succeed();
    }

    if (finished != nil) {
        finished();
    }
}

- (nullable NSURLSessionDataTask *)getForSimpleJson:(nonnull NSString *)path
                                              param:(nonnull NSDictionary *)param
                                            succeed:(nullable void (^)())succeed
                                             failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                           finished:(nullable void (^)())finished {
    NSAssert(path.length > 0, @"request path and json name must set");

    return [[TKNetworkManager sharedInstance]
            GET:[[TKRequestHandler sharedInstance] requestUrlForPath:path]
     parameters:[[TKRequestHandler sharedInstance] addExterParam:param]
        success:^(NSURLSessionDataTask *operation, id responseObject) {

            [self handleSuccessForSimpleJson:operation responseObject:responseObject succeed:succeed failed:failed finished:finished];
        }
        failure:^(NSURLSessionDataTask *operation, NSError *error) {

            [self handleFailure:operation error:error failed:failed finished:finished];
        }
    ];
}

- (nullable NSURLSessionDataTask *)postForSimpleJson:(nonnull NSString *)path
                                               param:(nonnull NSDictionary *)param
                                             succeed:(nullable void (^)())succeed
                                              failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                            finished:(nullable void (^)())finished {
    NSAssert(path.length > 0, @"request path and json name must set");
    return [[TKNetworkManager sharedInstance]
            POST:[[TKRequestHandler sharedInstance] requestUrlForPath:path]
      parameters:[[TKRequestHandler sharedInstance] addExterParam:param]
         success:^(NSURLSessionDataTask *operation, id responseObject) {

             [self handleSuccessForSimpleJson:operation responseObject:responseObject succeed:succeed failed:failed finished:finished];
         }
         failure:^(NSURLSessionDataTask *operation, NSError *error) {

             [self handleFailure:operation error:error failed:failed finished:finished];
         }
    ];
}

#pragma mark - Json

- (void)handleSuccessForJson:(NSURLSessionDataTask *)operation
              responseObject:(id)responseObject
                    jsonName:(NSString *)jsonName
                     succeed:(nullable void (^)(JSONModel *__nullable model))succeed
                      failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                    finished:(nullable void (^)())finished {
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        @try {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        } @catch (NSException *exception) {
            responseObject = nil;
        }
    }

    // 解析Json出错
    if (responseObject == nil) {
        TKResponseError *e = [TKResponseError
                errorWithType:TKResponseErrorTypeJsonFormat
                         code:0
                          msg:@"JsonFormat Error: response cant convert to Dictionary"];
        e.error = error;
        [self handleResponseError:e failed:failed finished:finished];
        return;
    }

    // 错误码错误
    NSInteger errNo = [responseObject[@"errno"] integerValue];
    if (errNo != 0) {
        TKResponseError *e = [TKResponseError
                errorWithType:TKResponseErrorTypeErrorNo
                         code:errNo
                          msg:[responseObject[@"errmsg"] description]];
        [self handleResponseError:e failed:failed finished:finished];
        return;
    }

    NSDictionary *dataDict = responseObject[@"data"];
    // 没有data结点，也认为是解析成功
    if (dataDict == nil) {
        if (succeed != nil) {
            succeed(nil);
        }

        if (finished != nil) {
            finished();
        }
        return;
    }

    Class clazz = NSClassFromString(jsonName);
    JSONModel *model = [(JSONModel *) [clazz alloc] initWithDictionary:dataDict error:&error];
    // 无法解析为JSONModel，可以认为是JSON解析错误
    if (model == nil) {
        TKResponseError *e = [TKResponseError
                errorWithType:TKResponseErrorTypeJsonFormat
                         code:0
                          msg:@"JsonFormat Error: cant parse to JSONModel"];
        e.error = error;

        [self handleResponseError:e failed:failed finished:finished];
        return;
    }

    if (succeed != nil) {
        succeed(model);
    }

    if (finished != nil) {
        finished();
    }

}

- (nullable NSURLSessionDataTask *)getForJson:(nonnull NSString *)path
                                        param:(nonnull NSDictionary *)param
                                         json:(nonnull NSString *)jsonName
                                      succeed:(nullable void (^)(JSONModel *__nullable model))succeed
                                       failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                     finished:(nullable void (^)())finished {
    NSAssert(path.length > 0 && jsonName.length > 0, @"request path and json name must set");

    return [[TKNetworkManager sharedInstance]
            GET:[[TKRequestHandler sharedInstance] requestUrlForPath:path]
     parameters:[[TKRequestHandler sharedInstance] addExterParam:param]
        success:^(NSURLSessionDataTask *operation, id responseObject) {

            [self handleSuccessForJson:operation responseObject:responseObject jsonName:jsonName
                               succeed:succeed failed:failed finished:finished];
        }
        failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [self handleFailure:operation error:error failed:failed finished:finished];
        }
    ];
}

- (nullable NSURLSessionDataTask *)postForJson:(nonnull NSString *)path
                                         param:(nonnull NSDictionary *)param
                                          json:(nonnull NSString *)jsonName
                                       succeed:(nullable void (^)(JSONModel *__nullable model))succeed
                                        failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                      finished:(nullable void (^)())finished {
    NSAssert(path.length > 0 && jsonName.length > 0, @"request path and json name must set");

    return [[TKNetworkManager sharedInstance]
            POST:[[TKRequestHandler sharedInstance] requestUrlForPath:path]
      parameters:[[TKRequestHandler sharedInstance] addExterParam:param]
         success:^(NSURLSessionDataTask *operation, id responseObject) {

             [self handleSuccessForJson:operation responseObject:responseObject jsonName:jsonName
                                succeed:succeed failed:failed finished:finished];
         }
         failure:^(NSURLSessionDataTask *operation, NSError *error) {
             [self handleFailure:operation error:error failed:failed finished:finished];
         }
    ];
}

#pragma mark - Json Array

- (void)handleSuccessForJsonArray:(NSURLSessionDataTask *)operation
                   responseObject:(id)responseObject
                         jsonName:(NSString *)jsonName
                          succeed:(nullable void (^)(NSArray *__nonnull modelArray))succeed
                           failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                         finished:(nullable void (^)())finished {
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        @try {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        } @catch (NSException *exception) {
            responseObject = nil;
        }
    }

    // 解析Json出错
    if (responseObject == nil) {
        TKResponseError *e = [TKResponseError
                errorWithType:TKResponseErrorTypeJsonFormat
                         code:0
                          msg:@"JsonFormat Error: response cant convert to Dictionary"];
        e.error = error;
        [self handleResponseError:e failed:failed finished:finished];
        return;
    }

    // 错误码错误
    NSInteger errNo = [responseObject[@"errno"] integerValue];
    if (errNo != 0) {
        TKResponseError *e = [TKResponseError
                errorWithType:TKResponseErrorTypeErrorNo
                         code:errNo
                          msg:[responseObject[@"errmsg"] description]];
        [self handleResponseError:e failed:failed finished:finished];
        return;
    }

    NSArray *dataArray = responseObject[@"data"];
    // 没有data结点，也认为是解析成功
    if (dataArray == nil) {
        dataArray = @[];
    }

    Class clazz = NSClassFromString(jsonName);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id obj in dataArray) {
        JSONModel *model = [(JSONModel *) [clazz alloc] initWithDictionary:obj error:&error];
        if (model != nil) {
            [array addObject:model];
        }
    }

    if (succeed != nil) {
        succeed(array);
    }

    if (finished != nil) {
        finished();
    }
}


- (nullable NSURLSessionDataTask *)getForJsonArray:(nonnull NSString *)path
                                             param:(nonnull NSDictionary *)param
                                              json:(nonnull NSString *)jsonName
                                           succeed:(nullable void (^)(NSArray *__nonnull modelArray))succeed
                                            failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                          finished:(nullable void (^)())finished {
    NSAssert(path.length > 0 && jsonName.length > 0, @"request path and json name must set");

    return [[TKNetworkManager sharedInstance]
            GET:[[TKRequestHandler sharedInstance] requestUrlForPath:path]
     parameters:[[TKRequestHandler sharedInstance] addExterParam:param]
        success:^(NSURLSessionDataTask *operation, id responseObject) {

            [self handleSuccessForJsonArray:operation responseObject:responseObject jsonName:jsonName
                                    succeed:succeed failed:failed finished:finished];
        }
        failure:^(NSURLSessionDataTask *operation, NSError *error) {

            [self handleFailure:operation error:error failed:failed finished:finished];
        }
    ];
}

- (nullable NSURLSessionDataTask *)postForJsonArray:(nonnull NSString *)path
                                              param:(nonnull NSDictionary *)param
                                               json:(nonnull NSString *)jsonName
                                            succeed:(nullable void (^)(NSArray *__nonnull modelArray))succeed
                                             failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                           finished:(nullable void (^)())finished {
    NSAssert(path.length > 0 && jsonName.length > 0, @"request path and json name must set");

    return [[TKNetworkManager sharedInstance]
            POST:[[TKRequestHandler sharedInstance] requestUrlForPath:path]
      parameters:[[TKRequestHandler sharedInstance] addExterParam:param]
         success:^(NSURLSessionDataTask *operation, id responseObject) {

             [self handleSuccessForJsonArray:operation responseObject:responseObject jsonName:jsonName
                                     succeed:succeed failed:failed finished:finished];
         }
         failure:^(NSURLSessionDataTask *operation, NSError *error) {

             [self handleFailure:operation error:error failed:failed finished:finished];
         }
    ];
}

@end
