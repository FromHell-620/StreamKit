//
//  TKModuleWebViewController.m
//  ToolKit
//
//  Created by chunhui on 15/7/28.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import "TKModuleWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

#define kRightButtonTag 10000
@interface TKModuleWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property(nonatomic , strong) NJKWebViewProgress *progressProxy;
@property(nonatomic , strong) UIProgressView *progressView;
@property(nonatomic , strong) NSURLRequest *request;
@property(nonatomic , strong) UIWebView *webView;

@end

@implementation TKModuleWebViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        _type = TKWebViewRightBarButtonItemTypeClose;
        _style = TKWebViewRightBarButtonItemStyleText;
        _isShowedGif = NO;
    }
    return self;
}

-(void)initNavbar
{
    if (self.backImage) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:self.backImage forState:UIControlStateNormal];
        button.bounds = CGRectMake(0, 0, 30, 40);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = item;
    }
    
    if(self.style == TKWebViewRightBarButtonItemStyleImage) {
        if(self.rightImages != nil) {
            UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22 * self.rightImages.count + 15, 22)];
            for (UIImage *image in self.rightImages) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                NSInteger index = [self.rightImages indexOfObject:image];
                CGFloat leftOffset = 0;
                if(index == 0) {
                    leftOffset = 37;
                } else if(index == 1) {
                    leftOffset = 0;
                }
                button.frame = CGRectMake(leftOffset, 0, 22, 22);
                [button setImage:image forState:UIControlStateNormal];
                [button sizeToFit];
                [button addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = kRightButtonTag + [self.rightImages indexOfObject:image];
                
                [rightView addSubview:button];
            }
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
            self.navigationItem.rightBarButtonItem = rightItem;
            
        }else if (self.rightImage != nil) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:self.rightImage forState:UIControlStateNormal];
            [button sizeToFit];
            [button addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
            self.navigationItem.rightBarButtonItem = item;
        }
    } else if(self.style == TKWebViewRightBarButtonItemStyleText && self.closeTitle.length > 0) {
        if (_closeColor) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:self.closeTitle forState:UIControlStateNormal];
            [button setTitle:self.closeTitle forState:UIControlStateHighlighted];
            [button setTitleColor:_closeColor forState:UIControlStateNormal];
            [button setTitleColor:_closeColor forState:UIControlStateHighlighted];
            [button sizeToFit];
            [button addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.rightBarButtonItem = item;
        }else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:self.closeTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
        }
    }
    
    if (self.progressView == nil) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
        CGRect frame = _progressView.frame;
        frame.origin.y = CGRectGetHeight(self.navigationController.navigationBar.frame) - CGRectGetHeight(frame);
        frame.size.width = CGRectGetWidth(self.view.bounds);
        _progressView.frame = frame;
        if(self.progressBarColor == nil){
            self.progressBarColor = [UIColor colorWithRed:94/255.0 green:176/266.0 blue:249/255.0 alpha:1];
        }
        _progressView.tintColor = self.progressBarColor;
    }
    
}

-(void)backAction:(id)sender
{
    if(_backByStep){
        
        if ([self.webView canGoBack]) {
            [self.webView goBack];
            return;
        }        
    }
    
    //[self closeAction:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonItemAction:(id)sender
{
    if(_type == TKWebViewRightBarButtonItemTypeClose) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if(_type == TKWebViewRightBarButtonItemTypeOther) {
        if(self.rightImages != nil) {
            UIBarButtonItem *item = (UIBarButtonItem *)sender;
            NSUInteger index = item.tag - kRightButtonTag;

            if (index == 0 && self.rightBarButtonItemAction) {
                NSString *title = self.title;
                NSString *shareContent = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
                
                self.rightBarButtonItemAction(self, title, shareContent);
            } else if(index == 1 && self.otherRightBarButtonItemAction) {
                NSString *title = self.title;
                NSString *shareContent = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
                
                self.otherRightBarButtonItemAction(self, title, shareContent);
            }
        } else if (self.rightImage != nil && self.rightBarButtonItemAction) {
            NSString *title = self.title;
            NSString *shareContent = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
            
            self.rightBarButtonItemAction(self, title, shareContent);
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_webView];
 
    [self initNavbar];
 
    self.progressProxy = [[NJKWebViewProgress alloc]init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    if (self.request) {
        [self loadRequest:_request];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadRequestWithUrl:(NSString *)url
{

    if (url.length > 3 &&  [[[url substringToIndex:3] lowercaseString] hasPrefix:@"www"]) {
        //默认使用http
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    
    NSURL *theURL = [NSURL URLWithString:url];
    if (theURL) {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:theURL];
        [self loadRequest:request];
    }
}

-(void)loadRequest:(NSURLRequest *)request
{
    if (self.webView) {
        [self.webView loadRequest:request];
    }else{
        self.request = request;
    }
}


-(void)updateTitle
{
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title.length > 0) {
        self.title = title;
    }
    
    if (_hiddenTitle) {
        self.title = nil;
    }
    
    if (_titleColor) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        titleLabel.textColor = _titleColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        titleLabel.text = self.title;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType != UIWebViewNavigationTypeLinkClicked) {
        if (self.loadWebViewStateHandle) {
            self.loadWebViewStateHandle(self, TKWebViewLoadStateStart, nil);
        }
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.loadWebViewStateHandle) {
        self.loadWebViewStateHandle(self, TKWebViewLoadStateFinish, nil);
    }
    [self updateTitle];
 
    if (!_enableUserPress) {
        //禁止用户选择
        NSString *js = @"document.documentElement.style.webkitUserSelect='none';";
        [webView stringByEvaluatingJavaScriptFromString:js];
        //用户长按
        js = @"document.documentElement.style.webkitTouchCallout='none';";
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.loadWebViewStateHandle) {
        self.loadWebViewStateHandle(self, TKWebViewLoadStateError, error);
    }
    [self updateTitle];
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    BOOL animated = YES;
    if (progress < self.progressView.progress) {
        //新的请求，不显示动画
        animated = NO;
    }
    [self.progressView setProgress:progress animated:animated];
    
    BOOL hidden = progress >= 0.999;
    if (hidden) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.hidden = true;
            [self.progressView setProgress:0 animated:NO];
        });
    }else{
        self.progressView.hidden = hidden;
    }
    
    
}


@end
