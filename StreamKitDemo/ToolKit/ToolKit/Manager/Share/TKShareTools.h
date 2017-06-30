//
//  TKShareTools.h
//  ToolKit
//
//  Created by wxc on 16/8/15.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TkShareData.h"
#import "TKShareResult.h"

@class CLLocation;

typedef NS_ENUM(int, TKSharePlatform){
    TKSharePlatformInvalid = 0,
    TKSharePlatformSinaWeibo = 1,
    
    TKSharePlatformQQ      = 2,         //QQ
    TKSharePlatformQzone   = 3,         //空间
    TKSharePlatformQQGroupTribe = 4,    //部落
    
    TKSharePlatformWXSession  = 5,      //好友
    TKSharePlatformWXTimeline = 6,      //朋友圈
    TKSharePlatformWXFavorite = 7,      //收藏
    
    TKSharePlatformLanjing = 8,         //蓝鲸
    
    TKSharePlatformSaveImage = 9999,    //保存图片
    
    TKSharePlatformOther = 10000,
};

@interface TKShareTools : NSObject

+(instancetype)sharedInstance;

/**
 *  微信注册
 *
 *  @param WXAppId
 *
 *  @return
 */
- (BOOL)registerWXAppId:(NSString*)WXAppId;


/**
 *  QQ注册
 *
 *  @param WXAppId
 *
 *  @return
 */
- (BOOL)registerQQAppId:(NSString*)QQAppId;

/**
 *  微博注册
 *
 *  @param WeiboAppId
 *
 *  @return
 */
- (BOOL)registerWeiboAppId:(NSString*)WeiboAppId redirectURI:(NSString*)redirectURI;

/**
 *
 *
 *  @param url
 *
 *  @return
 */
- (BOOL)handleOpenURL:(NSURL*)url;

/**
 *  
 *
 *  @param platformType        分享平台
 *  @param data                数据
 *  @param presentedController
 *  @param success             处理
 */
- (void)sendShareTo:(TKSharePlatform)platformType
         shareData:(TkShareData *)data
presentedController:(UIViewController *)presentedController
           responce:(void(^)(TKShareResult *result))success;

@end
