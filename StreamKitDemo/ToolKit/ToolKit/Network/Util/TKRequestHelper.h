//
// Created by 凯伦 on 2016/12/28.
// Copyright (c) 2016 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "TKResponseError.h"

@interface TKRequestHelper : NSObject

/**
 *  单例对象
 *
 *  @return 单例
 */
+(nonnull TKRequestHelper *)sharedInstance;

/**
 * 简单的Json Response处理器
 * 用于处理只包括errno, msg的简单Json
 * {
 *     "errno": 0,
 *     "msg": ""
 * }
 *
 * @param path      请求的url path或者完整的
 * @param param     请求的参数
 * @param succeed   成功的回调
 * @param failed    失败的回调，得到TKResponseError对象
 * @param finished  处理完成回调，不论succeed或者failed，都会回调finished
 * @return
 */
- (nullable NSURLSessionDataTask *)getForSimpleJson:(nonnull NSString *)path
                                              param:(nonnull NSDictionary *)param
                                            succeed:(nullable void (^)())succeed
                                             failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                           finished:(nullable void (^)())finished;

- (nullable NSURLSessionDataTask *)postForSimpleJson:(nonnull NSString *)path
                                               param:(nonnull NSDictionary *)param
                                             succeed:(nullable void (^)())succeed
                                              failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                            finished:(nullable void (^)())finished;

/**
 * 普通的Json Response请求
 * 用于处理只包括errno, msg和data的常规结构的Json
 * 它的抽象方法success返回的是data结点解析后得到的对象
 * {
 *     "errno": 0,
 *     "msg": "",
 *     "data": {
 *     }
 * }
 *
 * @param path      请求的url path或者完整的
 * @param param     请求的参数
 * @param jsonName  请求结果对应的JSONModel
 * @param succeed   成功的回调，得到data结点对应的JSONModel对象（如果data结点不存在，则参数model为nil）
 * @param failed    失败的回调，得到TKResponseError对象
 * @param finished  处理完成回调，不论succeed或者failed，都会回调finished
 * @return 请求的request
 */
- (nullable NSURLSessionDataTask *)getForJson:(nonnull NSString *)path
                                        param:(nonnull NSDictionary *)param
                                         json:(nonnull NSString *)jsonName
                                      succeed:(nullable void (^)(JSONModel *__nullable model))succeed
                                       failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                     finished:(nullable void (^)())finished;

- (nullable NSURLSessionDataTask *)postForJson:(nonnull NSString *)path
                                         param:(nonnull NSDictionary *)param
                                          json:(nonnull NSString *)jsonName
                                       succeed:(nullable void (^)(JSONModel *__nullable model))succeed
                                        failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                      finished:(nullable void (^)())finished;

/**
 * 数组形式Json Response请求
 * 用于处理只包括errno, msg和data的Json，并且data结点是一个数组
 * 它的抽象方法success返回的是data结点解析后得到的对象
 * {
 *     "errno": 0,
 *     "msg": "",
 *     "data": [
 *     ]
 * }
 *
 * @param path      请求的url path或者完整的
 * @param param     请求的参数
 * @param jsonName  请求结果对应的JSONModel
 * @param succeed   成功的回调，得到data结点对应的NSArray<JSONModel*>对象
 * @param failed    失败的回调，得到TKResponseError对象
 * @param finished  处理完成回调，不论succeed或者failed，都会回调finished
 * @return
 */
- (nullable NSURLSessionDataTask *)getForJsonArray:(nonnull NSString *)path
                                             param:(nonnull NSDictionary *)param
                                              json:(nonnull NSString *)jsonName
                                           succeed:(nullable void (^)(NSArray *__nonnull modelArray))succeed
                                            failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                          finished:(nullable void (^)())finished;

- (nullable NSURLSessionDataTask *)postForJsonArray:(nonnull NSString *)path
                                              param:(nonnull NSDictionary *)param
                                               json:(nonnull NSString *)jsonName
                                            succeed:(nullable void (^)(NSArray *__nonnull modelArray))succeed
                                             failed:(nullable void (^)(TKResponseError *__nonnull error))failed
                                           finished:(nullable void (^)())finished;

@end