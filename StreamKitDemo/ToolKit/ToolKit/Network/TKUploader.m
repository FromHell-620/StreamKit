//
//  FDUploader.m
//  Find
//
//  Created by chunhui on 15/5/9.
//  Copyright (c) 2015年 huji. All rights reserved.
//

#import "TKUploader.h"
#import "TKHttpParameter.h"
#import "AFURLRequestSerialization.h"


@implementation TKUploader

+ (NSURLSessionUploadTask *)uploadImage:(NSString *)URLString
                             parameters:(id)parameters
                              imageData:(NSData *)data
                              imageName:(NSString *)name
                               progress:(NSProgress *_Nullable *)progress
                             completion:(void (^)(NSURLResponse *response, id  responseImageJson , NSError *error))completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    TKHttpParameter *builder = [[TKHttpParameter alloc]init];
    [builder addKeyValueDict:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString] absoluteString] parameters:[builder build] constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
        if (data) {
            NSString *imageName = name;
            if (imageName.length == 0) {
                imageName = [NSString stringWithFormat:@"%.0f.png",[NSDate timeIntervalSinceReferenceDate]];
            }
            [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"image/jpeg"];
        }
        
    } error:&serializationError];
    if (serializationError) {
        if (completion) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(manager.completionQueue ?: dispatch_get_main_queue(), ^{
                completion(nil , nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        return nil;
    }
    
    NSURLSessionUploadTask * task =  [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (completion) {
            
            if (error ) {
                completion(response , responseObject , error);
            }else {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                }
                //            NSString *imageJson = nil;
                //            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                //                if ([[(NSDictionary *)responseObject objectForKey:@"errno"] integerValue] == 0) {
                //                    NSDictionary *data = [(NSDictionary *)responseObject objectForKey:@"data"];
                //                    NSData *jdata = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
                //                    imageJson = [[NSString alloc]initWithData:jdata encoding:NSUTF8StringEncoding];
                //                }
                //            }
                completion(response,responseObject,nil);
            }
        }
    }];

    [task resume];
    
    return task;
}

@end
