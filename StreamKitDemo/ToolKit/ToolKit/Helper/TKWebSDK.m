//
//  TKWebSDKManager.m
//  CaiLianShe
//
//  Created by chunhui on 2016/7/15.
//  Copyright © 2016年 chenny. All rights reserved.
//

#import "TKWebSDK.h"
#import <JavaScriptCore/JavaScriptCore.h>
@import WebKit;


#define kWebSDKName @"_weksdk_"

typedef id (^handle)(id param);

@interface TKWebSDK()

@property(nonatomic , strong) JSContext *jsContext;
@property(nonatomic , weak) UIViewController *controller;
@property(nonatomic , strong) NSArray *allImages;
@property(nonatomic , weak) WKWebView *webview;
@property(nonatomic , strong) NSMutableDictionary<NSString * , handle > *jsHandlers;

@end

@implementation TKWebSDK

+(WKWebViewConfiguration *)tkwkConfigurationWithJs:(NSString *)js
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    
    [userContentController addScriptMessageHandler:self name:kWebSDKName];
    
    WKUserScript *script = [[WKUserScript alloc]initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:false];
    [userContentController addUserScript:script];
    
    configuration.userContentController = userContentController;
    
    return configuration;
}

/*
 userinfo
 share
 login
 */
-(instancetype)initWithWebView:(nonnull UIWebView *)webview controller:(UIViewController *)controller
{
    JSContext *context = [webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    return [self initWithContext:context controller:controller];
}

-(instancetype)initWithWKWebView:(WKWebView **)webview controller:(UIViewController *)controller injectJS:(NSString *)js
{
    self = [self initWithContext:nil controller:controller];
    if (self) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        WKUserContentController *userContentController = [[WKUserContentController alloc]init];
        
        [userContentController addScriptMessageHandler:self name:kWebSDKName];
        
        WKUserScript *script = [[WKUserScript alloc]initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:false];
        [userContentController addUserScript:script];
        
        configuration.userContentController = userContentController;
        
        WKWebView *wkWebview = [[WKWebView alloc]initWithFrame:controller.view.bounds configuration:configuration];
        self.webview = wkWebview;
        *webview = wkWebview;
        
    }
    return self;
}

-(nonnull instancetype)initWKWebView:(WKWebView *)wkWebview WithController:(UIViewController *_Nullable)controller
{
    self = [self initWithContext:nil controller:controller];
    if (self) {
        self.webview = wkWebview;
    }
    return self;
}

-(instancetype)initWithContext:(JSContext *)context controller:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        self.jsContext = context;
        self.controller = controller;
        if (context) {
            [self registerDefaultActions];
        }else{
            _jsHandlers = [[NSMutableDictionary alloc]init];
            [self registerWKDefaultHandler];
        }
        
    }
    return self;
}

-(void)injectLoadDoneExecuteJs:(NSString *)js
{
    WKUserScript *script = [[WKUserScript alloc]initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:false];
    [self.webview.configuration.userContentController addUserScript:script];
    
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:kWebSDKName];
}

-(void)registerDefaultActions
{
    
    __weak typeof(self) wself = self;
    
    _jsContext[@"showimage"] = ^(){
        
        NSArray *args = [JSContext currentArguments];
        
        if (args.count >= 2) {
            JSValue *base64Value = [args firstObject];
            NSString *base64String = [base64Value toString];
            
            NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
            JSValue *urlValue = args[1];
            NSString *urlString = [urlValue toString];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.showImage(data,urlString);
            });
        }
    };
    
    _jsContext[@"allImages"] = ^{
        
        NSArray *args = [JSContext currentArguments];
        if(args.count > 0){
            JSValue *imgsValue = [args firstObject];
            NSArray *imgUrls = [imgsValue toArray];
            NSMutableArray *images = [[NSMutableArray alloc]init];
            for (id v in imgUrls) {
                if ([v isKindOfClass:[NSString class]]) {
                    [images addObject:v];
                }
            }
            
            wself.allImages = images;
        }
        
    };
    
    
    _jsContext[@"log"] = ^(){
#if DEBUG
        NSArray *args = [JSContext currentArguments];
        for (JSValue *v in args) {
            NSLog(@"++++ %@",v);
        }
#endif
    };
}


-(void)registerWKDefaultHandler
{
    __weak typeof(self) wself = self;
    
    _jsHandlers[@"allImages"] = ^(id param){
        
        NSDictionary *dict = param;
        NSArray *imgUrls = dict[@"urls"];
        NSMutableArray *images = [[NSMutableArray alloc]init];
        for (id v in imgUrls) {
            if ([v isKindOfClass:[NSString class]]) {
                [images addObject:v];
            }
        }
        
        wself.allImages = images;
        
        
        return [NSNull null];
    };
    
    _jsHandlers[@"showimage"] = ^(id param){
        
        NSDictionary *dict = param;
        NSString *url =dict[@"url"];
        if ([url isKindOfClass:[NSString class]] && url.length > 0 && wself.showImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.showImage(nil,url);
            });
        }
        
        return [NSNull null];
    };
    
    
    _jsHandlers[@"log"] = ^(id param){
        
        NSLog(@"%@",param);
        
        return [NSNull null];
    };
}


-(void)regsiterHandler:(NSString *)jsFunction action:(id(^)())action
{
    if (_jsContext) {
        _jsContext[jsFunction] = action;
    }else{
        _jsHandlers[jsFunction] = action;
    }
    
}

-(JSValue *)execute:(NSString *)jsCode
{
    if (_jsContext) {
        JSValue *value = [_jsContext evaluateScript:jsCode];
        
#if DEBUG
        NSLog(@"value is: %@",value);
#endif
        
        return value;
    }else{
        
        [self.webview evaluateJavaScript:jsCode completionHandler:^(id result, NSError * _Nullable error) {
            NSLog(@"error is: %@\n",error);
        }];
    }
    
    return nil;
    
}

-(NSArray *)allImageUrls
{
    return self.allImages;
}

-(nonnull UIViewController *)viewController
{
    return _controller;
}

#pragma mark wk web view

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:kWebSDKName]) {
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            NSDictionary *info = message.body;
            NSString *name = info[@"name"];
            id param = info[@"param"];
            _jsHandlers[name](param);
        }
    }
}


@end
