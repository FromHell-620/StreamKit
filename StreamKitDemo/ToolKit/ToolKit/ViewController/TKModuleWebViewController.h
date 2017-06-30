//
//  TKModuleWebViewController.h
//  ToolKit
//
//  Created by chunhui on 15/7/28.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  导航栏右部item样式
 */
typedef NS_ENUM(NSInteger, TKWebViewRightBarButtonItemStyle) {
    TKWebViewRightBarButtonItemStyleText,
    TKWebViewRightBarButtonItemStyleImage,
};

/**
 *  导航栏右部item样式为image时，对应操作
 *  close－一个item，关闭；other－两个item时对应操作
 */
typedef NS_ENUM(NSInteger, TKWebViewRightBarButtonItemType) {
    TKWebViewRightBarButtonItemTypeClose,
    TKWebViewRightBarButtonItemTypeOther,
};

typedef NS_ENUM(NSInteger, TKWebViewLoadState) {
    TKWebViewLoadStateStart,
    TKWebViewLoadStateFinish,
    TKWebViewLoadStateError,
};

@interface TKModuleWebViewController : UIViewController

@property(nonatomic , strong) UIImage *backImage;
@property(nonatomic , strong) UIImage *rightImage;
@property(nonatomic , strong) NSArray *rightImages;

/**
 *  导航栏右部关闭的title
 */
@property(nonatomic , copy)   NSString *closeTitle;
/**
 *  导航栏右部关闭的颜色
 */
@property(nonatomic , strong) UIColor *closeColor;
/**
 *  是否允许用户长按等操作
 */
@property(nonatomic , assign) BOOL enableUserPress;

/**
 *  点击返回是否相当上一页
 */
@property(nonatomic , assign) BOOL backByStep;

/**
 *  进度条颜色
 */
@property(nonatomic , strong) UIColor *progressBarColor;

/**
 *  是否隐藏标题
 */
@property(nonatomic , assign) BOOL hiddenTitle;

/**
 *  标题颜色
 */
@property(nonatomic , strong) UIColor *titleColor;

/**
 *  右边buttonItem类型
 */
@property(nonatomic, assign) TKWebViewRightBarButtonItemStyle style;
@property(nonatomic, assign) TKWebViewRightBarButtonItemType type;

/**
 *  右边buttonItem响应
 */
@property(nonatomic, copy) void (^rightBarButtonItemAction)(TKModuleWebViewController *webViewController , NSString *title , NSString *content);
@property(nonatomic, copy) void (^otherRightBarButtonItemAction)(TKModuleWebViewController *webViewController , NSString *title , NSString *content);

/**
 *  加载状态对应处理
 */
@property(nonatomic, copy) void (^loadWebViewStateHandle)(UIViewController *viewController, TKWebViewLoadState state, NSError* error);
/**
 *  是否已经显示过加载动画
 */
@property(nonatomic, assign) BOOL isShowedGif;

-(void)loadRequestWithUrl:(NSString *)url;

-(void)loadRequest:(NSURLRequest *)request;

@end
