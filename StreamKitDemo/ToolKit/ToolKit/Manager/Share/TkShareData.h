//
//  LJShareData.h
//  ShareTest
//
//  Created by chunhui on 15/3/7.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CLLocation;

typedef NS_ENUM(int, TKShareType){
    TKShareTypeWeb        = 0,
    TKShareTypeImage      = 1,
    TKShareTypeText       = 2,
    TKShareTypeMusic      = 3,
    TKShareTypeVideo      = 4,
    TKShareTypeEmotion    = 5,
    TKShareTypeFile       = 6,
    TKShareTypeAppContent = 7,
};

@interface TkShareData : NSObject

/**
 *  分享类型
 */
@property (nonatomic, assign) TKShareType shareType;

/**
 分享文字
 
 */
@property (nonatomic, copy) NSString *shareText;

/**
 分享图片
 
 */
@property (nonatomic, retain) id shareImage;

/**
 url资源类型，图片
 
 */
@property (nonatomic, copy) NSString *urlResource;


/**
 分享内容标题
 
 */
@property (nonatomic, copy) NSString *title;

/**
 应用链接地址,音乐、视频地址
 
 */
@property (nonatomic, copy) NSString *url;

/**
 数据url地址,分享音乐时，存储音乐播放源地址
 
 */
@property (nonatomic, copy) NSString *dataUrl;

/**
 表情数据, 支持gif
 
 */
@property (nonatomic, strong) NSData *emotionData;

/**
 文件格式
 
 */
@property (nonatomic, copy) NSString *fileExtension;

/**
 文件数据
 
 */
@property (nonatomic, strong) NSData *fileData;

/**
 App额外信息
 
 ContentData:(NSData *)data
 ExtInfo:(NSString *)info
 ExtURL:(NSString *)url
 
 */
@property (nonatomic, strong) NSDictionary *appExtendDict;

/*
 * 分享的地址
 */
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, copy) NSString *extends;

//是否必须显示title ，当为yes时，没有设置title时，以content的内容为title
@property (nonatomic, assign) BOOL forceShowTitle;


@end
