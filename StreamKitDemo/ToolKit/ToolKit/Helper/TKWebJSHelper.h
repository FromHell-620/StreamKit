//
//  TKWebJSHelper.h
//  ToolKit
//
//  Created by chunhui on 16/3/12.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKWebJSHelper : NSObject

@property (nonatomic, copy) void (^showImage)(NSData *imgageData , NSString *imgUrl);

-(instancetype)initWithWebView:(UIWebView *)webView;

-(NSArray *)allImageUrls;

-(void)addContextInfo;

-(void)regsiterHandler:(NSString *)jsFunction action:(void(^)())action;

/**
 *  注入js代码到webview
 *
 *  @param jsContent js代码
 */
-(void)injectJs:(NSString *)jsContent;

@end
