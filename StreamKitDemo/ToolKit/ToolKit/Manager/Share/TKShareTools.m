//
//  TKShareTools.m
//  ToolKit
//
//  Created by wxc on 16/8/15.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKShareTools.h"
#import "WXApi.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "WeiboSDK.h"
#import "TencentOpenAPI/TencentApiInterface.h"
#import "ImageHelper.h"
#import "TKAppInfo.h"
#import "TKNetworkManager.h"

@interface TKShareTools ()<WXApiDelegate,TencentSessionDelegate, WeiboSDKDelegate,QQApiInterfaceDelegate>
{
    NSString *_WXAppId;
    
    
    NSString *_QQAppId;
    
    
    NSString *_WeiboAppId;
    NSString *_WBAccessToken;
    
    __weak UIViewController *_presentedController;
    
    TKSharePlatform _currentSharePlatform;
    TkShareData *_currentData;
    
    NSString *_redirectURI;
}

//QQ授权
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, strong) WBAuthorizeRequest *request;

@property (nonatomic, copy)   void (^handleResult) (TKShareResult *response);

@property (nonatomic, assign) BOOL registeredQQ;

@end

@implementation TKShareTools

+(instancetype)sharedInstance
{
    static TKShareTools *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TKShareTools alloc]init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/**
 *  微信注册
 *
 *  @param WXAppId
 *
 *  @return
 */
- (BOOL)registerWXAppId:(NSString*)WXAppId
{
    _WXAppId = WXAppId;
     return [WXApi registerApp:WXAppId];
}

/**
 *  QQ注册
 *
 *  @param WXAppId
 *
 *  @return
 */
- (BOOL)registerQQAppId:(NSString*)QQAppId
{
    if (QQAppId == nil || QQAppId.length == 0) {
        return false;
    }
    _QQAppId = QQAppId;
    
    _tencentOAuth  = [[TencentOAuth alloc]initWithAppId:_QQAppId andDelegate:self];
    [_tencentOAuth getUserInfo];
    _registeredQQ = true;
    
    return YES;
}

/**
 *  微博注册
 *
 *  @param WeiboAppId
 *
 *  @return
 */
- (BOOL)registerWeiboAppId:(NSString*)WeiboAppId redirectURI:(NSString*)redirectURI
{
#if DEBUG
     [WeiboSDK enableDebugMode:YES];
#endif
    _WeiboAppId = WeiboAppId;
    _redirectURI = redirectURI;
    if (WeiboAppId.length > 0) {
        return [WeiboSDK registerApp:WeiboAppId];
    }
    return false;
    
}

/**
 *  handleOpenURL
 *
 *  @param url
 *
 *  @return
 */
- (BOOL)handleOpenURL:(NSURL*)url
{
    
    return [WeiboSDK handleOpenURL:url delegate:self] || [QQApiInterface handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

/*
 * 图片的缩略图
 */
-(NSData *)imageDataWith:(id)originalImage scale:(CGFloat)scale
{
    if ([originalImage isKindOfClass:[NSData class]]) {
        return originalImage;
    }else if([originalImage isKindOfClass:[UIImage class]]){
        return UIImageJPEGRepresentation(originalImage, scale);
    }else{
        return nil;
    }
}

/*
 * 图片的缩略图
 */
-(NSData *)thumbImage:(id)originalImage
{
    UIImage *image = nil;
    if ([originalImage isKindOfClass:[NSData class]]) {
        image = [UIImage imageWithData:originalImage];
    }else if([originalImage isKindOfClass:[UIImage class]]){
        image = originalImage;
    }
    
    if (image.size.width > 128) {
        image = [ImageHelper resizeImage:image maxWidth:128];
    }
    NSData *thumbData = UIImageJPEGRepresentation(image, 0.5);
    if (thumbData.length > 32*1000 || !image) {
        UIImage *icon = [TKAppInfo appIcon];
        thumbData = UIImageJPEGRepresentation(icon, 0.5);
    }
    return thumbData;
}

- (void)sendShareTo:(TKSharePlatform)platformType
         shareData:(TkShareData *)data
presentedController:(UIViewController *)presentedController
          responce:(void(^)(TKShareResult *result))success
{
    
    
    _handleResult = success;
    _presentedController = presentedController;
    _currentSharePlatform = platformType;
    _currentData = data;
    
    if (platformType == TKSharePlatformWXSession || platformType == TKSharePlatformWXTimeline || platformType == TKSharePlatformWXFavorite)
    {
        //微信
        [self handleWXShare:platformType shareData:data];
    }else if (platformType == TKSharePlatformQQ || platformType == TKSharePlatformQzone){
        
        //QQ
        [self handleQQShare:platformType shareData:data];
    }else if (platformType == TKSharePlatformSinaWeibo){
        
        //微博
        if (![WeiboSDK isWeiboAppInstalled]) {
            [self sendWeiBoRequest];
        }else{
            [self handleWeiboShare:_currentSharePlatform shareData:_currentData];
        }
    }
}

- (void)sendWeiBoRequest
{
    _request = [WBAuthorizeRequest request];
    _request.redirectURI = _redirectURI;
    _request.scope = @"all";
    _request.userInfo = nil;
    
    [WeiboSDK sendRequest:_request];
}

/**
 *  微信分享
 *
 *  @param platformType
 *  @param data
 */
- (void)handleWXShare:(TKSharePlatform)platformType shareData:(TkShareData *)data
{
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc]init];
    WXMediaMessage *message = [WXMediaMessage message];
    
    switch (data.shareType) {
        case TKShareTypeText:
        {
            //分享文字
            sendReq.text = data.title;
        }
            break;
        case TKShareTypeImage:
        {
            //分享图片
            WXImageObject *wximg = [WXImageObject object];
            
            wximg.imageData = [self imageDataWith:data.shareImage scale:0.7];
//            wximg.imageUrl = data.urlResource;
            message.mediaObject = wximg;
            message.thumbData = [self thumbImage:data.shareImage];
        }
            break;
        case TKShareTypeWeb:
        {
            //分享web
            message.title = data.title;
            WXWebpageObject *webpageObject = [WXWebpageObject object];
            
            webpageObject.webpageUrl = data.url;
            message.mediaObject = webpageObject;
            message.thumbData = [self thumbImage:data.shareImage];
            message.description = data.shareText;
        }
            break;
        case TKShareTypeMusic:
        {
            WXMusicObject *ext = [WXMusicObject object];
            ext.musicUrl = data.url;
            ext.musicDataUrl = data.dataUrl;
            
            message.title = data.title;
            message.description = data.shareText;
            message.mediaObject = ext;
            message.thumbData = [self thumbImage:data.shareImage];
        }
            break;
        case TKShareTypeVideo:
        {
            message.title = data.title;
            message.description = data.shareText;
            [message setThumbImage:[self thumbImage:data.shareImage]];
            
            WXVideoObject *ext = [WXVideoObject object];
            ext.videoUrl = data.url;
            
            message.mediaObject = ext;
        }
            break;
        case TKShareTypeEmotion:
        {
            [message setThumbImage:[self thumbImage:data.shareImage]];
            
            WXEmoticonObject *ext = [WXEmoticonObject object];
            ext.emoticonData = data.emotionData;
            
            message.mediaObject = ext;
        }
            break;
        case TKShareTypeFile:
        {
            message.title = data.title;
            message.description = data.shareText;
            [message setThumbImage:[self thumbImage:data.shareImage]];
            
            WXFileObject *ext = [WXFileObject object];
            ext.fileExtension = data.fileExtension;
            ext.fileData = data.fileData;
            
            message.mediaObject = ext;
        }
            break;
        case TKShareTypeAppContent:
        {
            WXAppExtendObject *ext = [WXAppExtendObject object];
            ext.extInfo = data.appExtendDict[@"ExtInfo"];
            ext.url = data.appExtendDict[@"ExtURL"];
            ext.fileData = data.appExtendDict[@"ContentData"];
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = data.title;
            message.description = data.shareText;
            message.mediaObject = ext;
            [message setThumbImage:[self thumbImage:data.shareImage]];
            
        }
            break;
        default:
            break;
    }
    
    if (data.shareType == TKShareTypeText) {
        sendReq.bText = YES;
    } else {
        sendReq.message = message;
        sendReq.bText = NO;
    }
    //分享到朋友圈或者好友
    switch (platformType) {
        case TKSharePlatformWXSession:
            sendReq.scene = WXSceneSession;
            break;
            
        case TKSharePlatformWXTimeline:
            sendReq.scene = WXSceneTimeline;
            break;
        case TKSharePlatformWXFavorite:
            sendReq.scene = WXSceneFavorite;
            break;
        default:
            break;
    }
    
    [WXApi sendReq:sendReq];
}

- (void)handleQQShare:(TKSharePlatform)platformType shareData:(TkShareData *)data
{
    SendMessageToQQReq *sendReq;
    switch (data.shareType) {
        case TKShareTypeText:
        {
            //分享文字,qzone分享不支持text类型分享
            QQApiTextObject *txtObj = [QQApiTextObject objectWithText:data.title];
            sendReq = [SendMessageToQQReq reqWithContent:txtObj];
        }
            break;
        case TKShareTypeImage:
        {
            //分享图片,qzone分享不支持image类型分享
            NSData *imageData = [self imageDataWith:data.shareImage scale:0.8];;
            NSData *thumbData = [self thumbImage:data.shareImage];
            
            if (platformType == TKSharePlatformQzone) {
                
                NSURL *url = [NSURL URLWithString:data.urlResource];
                QQApiURLObject *obj = [[QQApiURLObject alloc]initWithURL:url title:data.title description:data.shareText previewImageData:imageData targetContentType:QQApiURLTargetTypeNews];
                
                sendReq = [SendMessageToQQReq reqWithContent:obj];
                
            }else{
          
                
                QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imageData
                                                           previewImageData:thumbData
                                                                      title:data.title
                                                               description :data.shareText];
                
                sendReq = [SendMessageToQQReq reqWithContent:imgObj];
            }
        }
            break;
        case TKShareTypeWeb:
        {
            
            NSData *thumbData = [self thumbImage:data.shareImage];
            //分享web
            QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:data.url] title:data.title description:data.shareText previewImageData:thumbData];
            
            sendReq = [SendMessageToQQReq reqWithContent:newsObj];
        }
            break;
        case TKShareTypeMusic:
        {
            //分享跳转URL
            NSString *url = data.url;
            //音乐播放的网络流媒体地址
            NSString *flashURL = data.dataUrl;
            NSData *thumbData = [self thumbImage:data.shareImage];
            QQApiAudioObject *audioObj =[QQApiAudioObject
                                         objectWithURL :[NSURL URLWithString:url]
                                         title:data.title
                                         description:data.shareText
                                         previewImageData:thumbData];
            //设置播放流媒体地址
            audioObj.flashURL = flashURL;
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:audioObj];
        }
            break;
        case TKShareTypeVideo:
        {
            NSData *thumbData = [self thumbImage:data.shareImage];
            QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:data.url title:data.title description:data.shareText previewImageData:thumbData];
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:videoObj];
        }
            break;
        default:
            break;
    }
    
    QQApiSendResultCode resultCode;
    switch (platformType) {
        case TKSharePlatformQQ:
            resultCode = [QQApiInterface sendReq:sendReq];
            break;
        case TKSharePlatformQzone:
            resultCode = [QQApiInterface SendReqToQZone:sendReq];
            break;
        case TKSharePlatformQQGroupTribe:
//            resultCode = [QQApiInterface SendReqToQQGroupTribe:sendReq];
            break;
        default:
            break;
    }
    
    [self handleSendResult:resultCode];
}

- (void)handleWeiboShare:(TKSharePlatform)platformType shareData:(TkShareData *)data
{
    WBMessageObject *message = [[WBMessageObject alloc]init];
    WBSendMessageToWeiboRequest *request;;
    
    switch (data.shareType) {
        case TKShareTypeText:
        {
            //分享文字
            message.text = data.title;
            request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:_request access_token:_WBAccessToken];
        }
            break;
        case TKShareTypeImage:
        {
            //分享图片
            NSData *imageData = [self imageDataWith:data.shareImage scale:0.8];
            
            WBImageObject *imageObj = [[WBImageObject alloc]init];
            imageObj.imageData = imageData;
            message.imageObject = imageObj;
            message.text = [NSString stringWithFormat:@"%@%@",data.shareText,data.url];
            
            //check
            if (message.text.length > 144) {
                message.text = [message.text substringToIndex:143];
            }
            
            request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:_request access_token:_WBAccessToken];
        }
            break;
        case TKShareTypeWeb:
        {
            //分享web
            WBWebpageObject *newsObj = [[WBWebpageObject alloc]init];
            
            newsObj.objectID = data.url;
            newsObj.webpageUrl = data.url;
            newsObj.title = data.title;
            newsObj.description = data.shareText;
            newsObj.thumbnailData = [self thumbImage:data.shareImage];
            
            message.mediaObject = newsObj;
            
            request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:_request access_token:_WBAccessToken];
        }
            break;
            
        default:
            break;
    }
    
    [WeiboSDK sendRequest:request];
}

#pragma mark 微信回调
/**
 *  onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
 *
 *  @param req
 */
-(void) onReq:(BaseReq*)req
{
    
}

/**
 *  如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
 *
 *  @param resp
 */
-(void) onWXResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        TKShareResult *response = [[TKShareResult alloc]init];
        if (resp.errCode == WXSuccess) {
            response.success = YES;
        }else{
            response.success = NO;
        }
        
        if (_handleResult) {
            _handleResult(response);
        }
    }
}


/**
 处理来至QQ的响应
 */
- (void)onResp:(id)resp
{
    if ([resp isKindOfClass:[QQBaseResp class]]) {
        [self onQQResp:resp];
    }else if ([resp isKindOfClass:[BaseResp class]]){
        [self onWXResp:resp];
    }
}



/**
 处理来至QQ的响应
 */
- (void)onQQResp:(QQBaseResp *)resp
{
    if (resp.type == ESENDMESSAGETOQQRESPTYPE) {
        TKShareResult *response = [[TKShareResult alloc]init];
        response.success = (resp.errorDescription.length == 0);
        
        //分享空间，暂时不作处理，后期SDK更新，放开
//        if (_currentSharePlatform == TKSharePlatformQzone) {
//            return;
//        }
        
        if (_handleResult) {
            _handleResult(response);
        }
    }
}

//处理结果
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    TKShareResult *response = [[TKShareResult alloc]init];
    if (sendResult == EQQAPISENDSUCESS) {
        response.success = YES;
    }else{
        response.success = NO;
        if (_handleResult) {
            _handleResult(response);
        }
    }
}

#pragma mark 微博delegate
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"requet is: %@",request);
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
        
        TKShareResult *responseResult = [[TKShareResult alloc]init];
        switch (response.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess:
            {
                //成功
                responseResult.success = YES;
            }
                break;
                default:
            {
                responseResult.success = NO;
            }
        }
        
        if (_handleResult) {
            _handleResult(responseResult);
        }
    }else if ([response isKindOfClass:WBAuthorizeResponse.class]){
        if (0 == response.statusCode) {
            //授权成功
            WBAuthorizeResponse *authorizeResponse = (WBAuthorizeResponse*)response;
            _WBAccessToken = authorizeResponse.accessToken;
            [self handleWeiboShare:_currentSharePlatform shareData:_currentData];
        }else {
            //授权失败
            if (_handleResult) {
                NSString *info = response.userInfo[@"error"];
                if (info == nil) {
                    info = @"微博分享失败";
                }
                TKShareResult *responseResult = [[TKShareResult alloc]init];
                responseResult.success = false;
                responseResult.resultDescription = info;
                _handleResult(responseResult);
            }
        }
    }
}

@end
