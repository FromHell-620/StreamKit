//
//  FDUploader.h
//  Find
//
//  Created by chunhui on 15/5/9.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface TKUploader : NSObject
/**
 *  上传图片资源
 *
 *  @param URLString  上传的地址
 *  @param parameters 请求的参数
 *  @param data       图片nsdata
 *  @param name       图片名称
 *  @param progress   上传进度对象
 *  @param success    成功回调
 *  @param failure    失败
 *
 *  @return 请求对象
 */
+ ( NSURLSessionUploadTask *_Nullable)uploadImage:( NSString *_Nonnull)URLString
                             parameters:(_Nullable id)parameters
                              imageData:(NSData *_Nonnull)data
                              imageName:(NSString *_Nonnull)name
                               progress:(NSProgress *_Nullable *_Nullable)progress
                             completion:(void (^_Nullable)(NSURLResponse *_Nullable response, id _Nullable  responseImageJson , NSError *_Nullable error))completion;




@end
