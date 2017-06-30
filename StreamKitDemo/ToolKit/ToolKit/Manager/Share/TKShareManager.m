//
//  TKShareManager.m
//  ShareTest
//
//  Created by chunhui on 15/3/7.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import "TKShareManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "TKShareView.h"
#import "TKAppInfo.h"
//#import "UMSocialSinaSSOHandler.h"
#import "WeiboSDK.h"
#import "SDWebImageDownloader.h"

#define kOpenAnalyse 1

#if kOpenAnalyse

#import <UMMobClick/MobClick.h>

#endif

@interface TKShareManager ()

@property(nonatomic , strong) TkShareData *currentShareData;
@property(nonatomic , copy)   void(^doneBlock)(BOOL success);

@end


@implementation TKShareManager

+(instancetype)sharedInstance
{
    static TKShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TKShareManager alloc]init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _shareContentMaxLength = 140;
        _weiboShowEdit = NO;
    }
    return self;
}

-(void)registerKeys
{
//    NSAssert(_umengKey.length > 0 , @"share umeng key must set");
//    NSAssert(_wxAppId.length > 0 , @"share weixin app id secret  must set");
//    NSAssert(_qqAppId.length > 0 && _qqAppKey.length > 0 && _qqAppUrl.length > 0, @"share qq app id key url must set");

    //注册微信
    [[TKShareTools sharedInstance] registerWXAppId:_wxAppId];
    
    //注册QQ
    [[TKShareTools sharedInstance] registerQQAppId:_qqAppId];
    
    //设置新浪微博的回调url
    NSString *weiboUrl = self.weiboRedirectUrl;
    if (weiboUrl.length == 0) {
        weiboUrl = @"http://sns.whalecloud.com/sina2/callback";
    }
    [[TKShareTools sharedInstance]registerWeiboAppId:_weiboAppKey redirectURI:weiboUrl];
    
    [MobClick setCrashReportEnabled:NO];
    
    //for analyse
#if kOpenAnalyse
    
    [MobClick setAppVersion:[TKAppInfo appVersion]];
    UMConfigInstance.appKey = _umengKey;
#if DEBUG
    UMConfigInstance.ePolicy = SEND_INTERVAL;
#else
    UMConfigInstance.ePolicy = BATCH;
#endif
    UMConfigInstance.channelId = _channelId;
    [MobClick startWithConfigure:UMConfigInstance];
    
#if DEBUG
    [MobClick setLogEnabled:NO];
#else
    [MobClick setLogEnabled:NO];    
#endif
    
#endif
    
    
}

+(void)postShareTo:(TKSharePlatform)type
         shareData:(TkShareData *)data
presentedController:(UIViewController *)presentedController
           success:(void(^)(BOOL success))successResonce
{
    TKShareManager *manager = [TKShareManager sharedInstance];

    if(data.shareText.length == 0){
        if (data.title) {
            data.shareText = data.title;
        }else{
            data.shareText = [manager defaultShareTitle];
        }
    }
    if(data.shareImage == nil){
        data.shareImage = [manager defaultShareImage];
    }
    //控制title的最大长度
    if (data.title.length > manager.shareContentMaxLength) {
        data.title = [data.title substringToIndex:manager.shareContentMaxLength -1 ];
    }
    
    if (type == TKSharePlatformWXSession || type == TKSharePlatformWXTimeline || type == TKSharePlatformWXFavorite) {
        manager.doneBlock = successResonce;
    }
    
    if (data.urlResource.length > 0) {
        NSURL *imgUrl = [NSURL URLWithString:data.urlResource];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imgUrl options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *imgdata, NSError *error, BOOL finished) {
            if (error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (successResonce) {
                         successResonce(false);
                     }
                 });
            }else{
                
                data.shareImage = imgdata;
                data.urlResource = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[TKShareTools sharedInstance] sendShareTo:type shareData:data presentedController:presentedController responce:^(TKShareResult *result) {
                        if (successResonce) {
                            successResonce(result.success);                            
                        }
                    }];
                });
            };
        }];
        return;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[TKShareTools sharedInstance] sendShareTo:type shareData:data presentedController:presentedController responce:^(TKShareResult *result) {
                if (successResonce) {
                    successResonce(result.success);
                }
            }];
        });
    }
}

+(void)showShareChooseWithData:(TkShareData *)data presentedController:(UIViewController *)presentedController success:(void(^)(BOOL success,NSInteger type))success
{
    TKShareView *shareView = [TKShareView DefaultShareView];
    shareView.shareTo = ^(TKSharePlatform platform){
        if (platform != TKSharePlatformInvalid) {
            
            [self postShareTo:platform shareData:data presentedController:presentedController success:^(BOOL succes) {
                success(succes,platform);
            }];
        }                
    };
    [shareView showInView:nil];
    
    
}

//检测微信是否可用
+(BOOL)isWeixinInstalled
{
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

//检测QQ是否可用
+(BOOL)isQQInstalled
{
    return [QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi];
}

+ (BOOL)handleOpenURL:(NSURL*)url
{
    return [[TKShareTools sharedInstance]handleOpenURL:url];
}

+(void)handleWeixinShare:(SendMessageToWXResp *)resp
{
    TKShareManager *manager = [TKShareManager sharedInstance];
    if (manager.doneBlock) {
        manager.doneBlock(resp.errCode == WXSuccess);
    }
}


@end


