//
//  FDNetworkManager.h
//  Find
//
//  Created by chunhui on 15/5/9.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"
@import Security;

extern NSString *_Nonnull kTKNetworkChangeNotification;

@protocol TKNetworkManagerDelegate;

@interface TKNetworkManager : NSObject

@property(nonatomic , weak , nullable) id<TKNetworkManagerDelegate> delegate;

@property(nonatomic , assign) NSTimeInterval timeoutInterval;

@property(nonatomic , strong , nullable) NSDictionary *extraHeaderParam;

+( TKNetworkManager *_Nullable)sharedInstance;

///---------------------------
/// @name Making HTTP Requests
///---------------------------

/**
 Creates and runs an `NSURLSessionDataTask` with a `GET` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 
 @see -dataTaskWithRequest:completionHandler:
 */
- ( NSURLSessionDataTask * _Nullable )GET:(NSString *_Nonnull )URLString
                               parameters:( id _Nullable)parameters
                                  success:(void (^ _Nullable )(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success
                                  failure:( void (^_Nullable)(NSURLSessionDataTask *_Nonnull task, NSError *_Nullable error))failure;

- (nullable NSURLSessionDataTask *)RAWGET:(NSString *_Nonnull)URLString
                               parameters:(nullable id)parameters
                                  success:( void (^_Nullable)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success
                                  failure:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, NSError *_Nullable error))failure;

/**
 Creates and runs an `NSURLSessionDataTask` with a `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 
 @see -dataTaskWithRequest:completionHandler:
 */
- (NSURLSessionDataTask *_Nullable)POST:(NSString *_Nonnull)URLString
                             parameters:(nullable id)parameters
                                success:(void (^ _Nullable )(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success
                                failure:( void (^_Nullable)(NSURLSessionDataTask *_Nonnull task, NSError *_Nullable error))failure;

/**
 Creates and runs an `NSURLSessionDataTask` with a multipart `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param block A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `AFMultipartFormData` protocol.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 
 @see -dataTaskWithRequest:completionHandler:
 */
- (NSURLSessionDataTask *_Nullable)POST:(NSString *_Nonnull)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> _Nullable formData))block
                                success:(nullable void (^)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nullable error))failure;

/**
 Creates an `NSURLSessionDownloadTask` with the specified request.
 
 @param request The HTTP request for the request.
 @param progress A progress object monitoring the current download progress.
 @param destination A block object to be executed in order to determine the destination of the downloaded file. This block takes two arguments, the target path & the server response, and returns the desired file URL of the resulting download. The temporary file used during the download will be automatically deleted after being moved to the returned URL.
 @param completionHandler A block to be executed when a task finishes. This block has no return value and takes three arguments: the server response, the path of the downloaded file, and the error describing the network or parsing error that occurred, if any.
 
 @warning If using a background `NSURLSessionConfiguration` on iOS, these blocks will be lost when the app is terminated. Background sessions may prefer to use `-setDownloadTaskDidFinishDownloadingBlock:` to specify the URL for saving the downloaded file, rather than the destination block of this method.
 */
-(nullable NSURLSessionTask *)download:(nonnull NSString *)URLString
                              progress:(NSProgress * __nullable __autoreleasing * __nullable)progress
                           destination:(nullable NSURL *_Nonnull (^)( NSURL *_Nonnull targetPath, NSURLResponse * _Nonnull response))destination
                     completionHandler:(nullable void (^)(NSURLResponse *_Nonnull response, NSURL * __nullable filePath, NSError * __nullable error))completionHandler;

-(BOOL)handleResponse:(nullable NSDictionary *)response;


#pragma mark - net check
-(void)stopNotifier;
-(void)startNotifier;
-(BOOL)networkReachable;
//当前网络状态
-(NetworkStatus)networkStatus;

#pragma mark - https cers
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

/*
 * 双向认证时加载客户端的 p12文件
 * @param password 密码
 */
-(void)loadClientP12:(NSString *_Nonnull)p12Path password:(NSString *_Nonnull)password;


-(NSString *_Nullable)clientP12Path;

-(NSString *_Nullable)clientPassword;

/*
 * 设置忽略错误处理的请求路径
 */
-(void)setIgnoreErrorCodePaths:(NSArray *_Nullable)ignorePaths;


-(BOOL)extractIdentity:(SecIdentityRef _Nullable * _Nullable)outIdentity andTrust:(SecTrustRef  _Nullable * _Nullable)outTrust fromPKCS12Data:(NSData * _Nonnull)inPKCS12Data withPassword:(NSString *_Nullable)password;


@end


@protocol TKNetworkManagerDelegate <NSObject>

-(void)checkError:(NSInteger)errNo responseData:(NSDictionary *_Nonnull)response forRequest:(NSURLRequest *_Nonnull)request;

@end
