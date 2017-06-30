//
//  TKRequestHandler.h
//  ToolKit
//
//  Created by chunhui on 15/10/9.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"
#import "TKCommons.h"

extern NSString *_Nonnull kRequestNetErrorTip;
extern NSString *_Nonnull kRequestFailedTip;

@class AFHTTPRequestOperation;
@class JSONModel;

@protocol TKRequestHandlerDatasource;
@protocol TKRequestHandlerDelegate;

@interface TKRequestHandler : NSObject

@property(nonatomic , weak , nullable)  id<TKRequestHandlerDelegate> delegate;
@property(nonatomic , strong , nullable) NSString *host;
@property(nonatomic , assign) NSTimeInterval timeoutInterval;//默认超时时间
@property(nonatomic , strong , nullable) NSDictionary *extraHeaderParam;//请求header参数
@property(nonatomic , strong , nullable) NSDictionary *baseParam;
//extraInfoBlock 返回 用户信息 网络状态等 随时变化的数据
@property(nonatomic , copy , nullable)   NSDictionary<NSString *  , NSString* > *_Nullable (^  extraInfoBlock )();
@property(nonatomic , copy , nullable)   NSString *_Nullable (^codeSignBlock)(NSDictionary<NSString * , NSObject *> * _Nonnull param);

/**
 *  单例对象
 *
 *  @return 单例
 */
+(TKRequestHandler *_Nonnull)sharedInstance;


#pragma mark - 设置证书相关
/*
 * 设置https使用的证书
 * @param cerPath 证书路径
 */
-(void)loadCerWithPath:(NSString *_Nonnull)cerPath;
/*
 * 设置https使用的证书
 * @param cerPaths 多个证书路径
 */
-(void)loadCersWithPaths:(NSArray *_Nonnull)cerPaths;
/*
 * 设置https使用的证书 使用bundle下所有的cer文件
 */
-(void)loadAllDefaultCers;

- (NSString *)requestUrlForPath:(NSString *)path;

-(NSDictionary *)addExterParam:(NSDictionary *)param;


/**
 *  JSONModel通用GET请求
 *
 *  @param path     请求的url path或者完整的
 *  @param param    请求的参数
 *  @param jsonName 请求结果对应的JSONModel
 *  @param finish   处理完成回调
 *
 *  @return 请求的request
 */
-(NSURLSessionDataTask *_Nullable)getRequestForPath:(NSString *_Nonnull)path param:(NSDictionary *_Nullable)param jsonName:(NSString *_Nonnull)jsonName finish:(void (^_Nullable)(NSURLSessionDataTask *_Nonnull sessionDataTask, JSONModel *_Nullable model , NSError *_Nullable error))finish;
/**
 *  JSONModel通用POST请求
 *
 *  @param path     请求的url path或者完整的
 *  @param param    请求的参数
 *  @param jsonName 请求结果对应的JSONModel
 *  @param finish   处理完成回调
 *
 *  @return 请求的request
 */
-(NSURLSessionDataTask *_Nullable)postRequestForPath:(NSString *_Nonnull)path param:(NSDictionary *_Nullable)param jsonName:(NSString *_Nonnull)jsonName finish:(void (^_Nullable)(NSURLSessionDataTask *_Nullable sessionDataTask, JSONModel *_Nullable model , NSError *_Nullable error))finish;
/**
 *  通用get请求
 *
 *  @param path   请求的路径
 *  @param param  请求的参数
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *_Nullable)getRequestForPath:(NSString *_Nonnull)path param:(NSDictionary *_Nullable)param  finish:(void (^_Nullable)(NSURLSessionDataTask *_Nullable sessionDataTask, id _Nullable response , NSError *_Nullable error))finish;

/**
 *  下载文件
 *
 *  @param path     文件url
 *  @param progress 进度
 *  @param finish   完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *_Nullable)downloadFile:(NSString *_Nonnull)path progress:(void(^_Nullable)(CGFloat progress))progress targetPath:(NSURL *_Nullable)destinationPath finish:(void (^_Nullable)(NSURLSessionDataTask *_Nullable sessionDataTask, NSString *_Nullable path , NSError *_Nullable error))finish;

/**
 *  下载文件
 *
 *  @param path   文件地址
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *_Nullable)downloadFile:(NSString *_Nonnull)path  finish:(void (^_Nullable)(NSURLSessionDataTask *_Nullable sessionDataTask,  NSString *_Nullable downloadPath , NSError *_Nullable error))finish;

/**
 *  通用post请求
 *
 *  @param path   请求的path
 *  @param param  请求的参数
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *_Nullable)postRequestForPath:(NSString *_Nonnull)path param:(NSDictionary *_Nullable)param finish:(void (^_Nullable)(NSURLSessionDataTask *_Nullable sessionDataTask, id _Nullable response , NSError *_Nullable error))finish;


/**
 *  通用post请求（formData)
 *
 *  @param path       请求的path
 *  @param param      请求参数
 *  @param jsonName   处理返回数据的jsonmodel对象的类名
 *  @param block      二进制数据构造block
 *  @param finish     完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *_Nullable)postRequestForPath:(NSString *_Nonnull)path param:(NSDictionary *_Nullable)param jsonName:(NSString *_Nullable)jsonName formData:(void (^_Nullable)(id <AFMultipartFormData> _Nullable formData))block finish:(void (^_Nullable)(NSURLSessionDataTask *_Nullable sessionDataTask, JSONModel *_Nullable model , NSError *_Nullable error))finish;

/**
 *  通用二进制post请求
 *
 *  @param path   请求path
 *  @param param  请求参数
 *  @param block  二进制构造block
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *_Nullable)postRequestForPath:(NSString *_Nonnull)path param:(NSDictionary *_Nullable)param formData:(void (^_Nullable)(id <AFMultipartFormData> _Nullable formData))block finish:(void (^_Nullable)(NSURLSessionDataTask *_Nullable sessionDataTask, id _Nullable response , NSError *_Nullable error))finish;

@end


@protocol TKRequestHandlerDelegate <NSObject>

@optional

-(void)checkError:(NSInteger)errNo responseData:(NSDictionary *_Nullable)response;

-(void)checkError:(NSInteger)errNo responseData:(NSDictionary *_Nullable)response forRequest:(NSURLRequest *_Nonnull)request;
/**
 *  转换系统的error为将系统可提示的
 *
 *  @param error 系统的错误
 *
 *  @return 应用提示用的error
 */
-(NSError *_Nullable)convertError:(NSError *_Nullable)error;

@end
