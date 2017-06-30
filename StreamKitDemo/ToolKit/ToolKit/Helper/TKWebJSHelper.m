//
//  TKWebJSHelper.m
//  ToolKit
//
//  Created by chunhui on 16/3/12.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKWebJSHelper.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface TKWebJSHelper ()

@property(nonatomic , strong) UIWebView *webView;
@property(nonatomic , strong) NSArray *allImages;

@end

@implementation TKWebJSHelper

-(instancetype)initWithWebView:(UIWebView *)webView
{
    self = [super init];
    if (self) {
        self.webView = webView;
    }
    return self;
}

-(void)addContextInfo
{
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    __weak typeof(self) wself = self;
    context[@"showimage"] = ^(){
        
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
    
    context[@"allImages"] = ^{
        
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
    
#if DEBUG
    context[@"log"] = ^(){
        
        NSArray *args = [JSContext currentArguments];
        for (JSValue *v in args) {
            NSLog(@" %@",v);
        }
    };
    
#endif

}

-(NSArray *)allImageUrls
{
    return self.allImages;
}

-(void)regsiterHandler:(NSString *)jsFunction action:(void(^)())action
{
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[jsFunction] = action;
}


-(void)injectJs:(NSString *)jsContent
{
    [self.webView stringByEvaluatingJavaScriptFromString:jsContent];
}

@end
