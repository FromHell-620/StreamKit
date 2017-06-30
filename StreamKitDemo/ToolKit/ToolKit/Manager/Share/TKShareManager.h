//
//  TKShareManager.h
//  ShareTest
//
//  Created by chunhui on 15/3/7.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TkShareData.h"
#import "TKShareTools.h"

@protocol TKShareManagerDatasource;
@class SendMessageToWXResp;
@interface TKShareManager : NSObject

/**
 *  微博分享的时候是否显示编辑页面
 *  默认不显示
 */
@property(nonatomic , assign) BOOL weiboShowEdit;
/**
 *  分享的最长长度，默认是140
 */
@property(nonatomic , assign) NSInteger shareContentMaxLength;
/**
 *  分享相关
 */
@property(nonatomic , copy) NSString *umengKey;
@property(nonatomic , copy) NSString *wxAppId;
@property(nonatomic , copy) NSString *wxAppSecret;
@property(nonatomic , copy) NSString *wxAppUrl;
@property(nonatomic , copy) NSString *qqAppId;
@property(nonatomic , copy) NSString *qqAppKey;
@property(nonatomic , copy) NSString *qqAppUrl;
@property(nonatomic , copy) NSString *weiboAppKey;
@property(nonatomic , copy) NSString *weiboAppSecret;
@property(nonatomic , copy) NSString *weiboRedirectUrl;
@property(nonatomic , copy) NSString *defaultShareTitle;
@property(nonatomic , strong) UIImage *defaultShareImage;

/**
 *  渠道号
 */
@property(nonatomic , copy) NSString *channelId;

+(instancetype)sharedInstance;

/**
 *  注册各平台分享
 */
-(void)registerKeys;

+(void)postShareTo:(TKSharePlatform)type
         shareData:(TkShareData *)data
presentedController:(UIViewController *)presentedController
           success:(void(^)(BOOL success))successResonce;

+(void)showShareChooseWithData:(TkShareData *)data presentedController:(UIViewController *)presentedController success:(void(^)(BOOL success,NSInteger type))success;


//+(void)thirdPartyLoginWithPlatType:(TKSharePlatform )type inController:(UIViewController *)controller doneBlock:(void(^)(UMSocialAccountEntity * entity) )block;

+(BOOL)isWeixinInstalled;
+(BOOL)isQQInstalled;

+(void)handleWeixinShare:(SendMessageToWXResp *)resp;

+(BOOL)handleOpenURL:(NSURL*)url;

@end

