//
//  TKWebSDK.h
//  CaiLianShe
//
//  Created by chunhui on 2016/7/15.
//  Copyright © 2016年 chenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WKWebView;
@class JSContext;
@class JSValue;
@class UIWebView;
@class UIViewController;
@class WKWebViewConfiguration;
@protocol WKScriptMessageHandler;

@interface TKWebSDK : NSObject

// images
@property (nonatomic, copy , nullable) void (^ showImage)( NSData * _Nullable imgageData ,   NSString *_Nullable imgUrl);

-(nonnull instancetype)initWithWebView:(nonnull UIWebView *)webview controller:(nonnull UIViewController *)controller;

-(nonnull instancetype)initWithWKWebView:( WKWebView * _Nullable * _Nullable)webview controller:(nonnull UIViewController *)controller injectJS:(nonnull NSString *)js;

-(nonnull instancetype)initWithContext:(nonnull JSContext *)context controller:(nonnull UIViewController *)controller;

-(nonnull instancetype)initWKWebView:(WKWebView *_Nonnull)wkWebview WithController:(UIViewController *_Nullable)controller;

-(void)regsiterHandler:(nonnull NSString *)jsFunction action:(_Nullable id (^ _Nullable )())action;
/*
 * 注入wkwebview加载完成时执行的js
 */
-(void)injectLoadDoneExecuteJs:(NSString *_Nonnull)js;

-(nullable JSValue *)execute:(nonnull NSString *)jsCode;

-(nullable NSArray *)allImageUrls;

-(nonnull UIViewController *)viewController;

+(WKWebViewConfiguration *_Nonnull)tkwkConfigurationWithJs:(NSString *_Nonnull)js;

@end
