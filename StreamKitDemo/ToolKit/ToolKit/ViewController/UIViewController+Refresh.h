//
//  LJBaseViewController+Refresh.h
//  news
//
//  Created by chunhui on 15/12/6.
//  Copyright © 2015年 lanjing. All rights reserved.
//
@import UIKit;

@interface UIViewController (Refresh)
/**
 *  添加上下拉刷新
 *
 *  @param scrollView 要添加的view
 */
-(void)addRefreshView:(UIScrollView *)scrollView;

/**
 *  添加下拉刷新
 *
 *  @param scrollView 要添加的view
 */
-(void)addHeaderRefreshView:(UIScrollView *)scrollView;

/**
 *  添加上拉刷新
 *
 *  @param scrollView 要添加的view
 */
-(void)addFooterRefreshView:(UIScrollView *)scrollView;

/**
 *  添加下拉刷新 （block）
 *
 *  @param scrollView 要添加的view
 *  @param callback   回调方法
 */
-(void)addHeaderRefreshView:(UIScrollView *)scrollView callBack:(void(^)())callback;

/**
 *  添加上拉杀心 （block）
 *
 *  @param scrollView 要添加的view
 *  @param callback   回调方法
 */
-(void)addFooterRefreshView:(UIScrollView *)scrollView callBack:(void (^)())callback;

/**
 *  停止刷新
 *
 *  @param scrollView 要停止的view
 */
-(void)stopRefresh:(UIScrollView *)scrollView;

/**
 *  开始上啦刷新
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)startHeadRefresh:(UIScrollView *)scrollView;

/**
 *  开始下拉刷新
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)startFootRefresh:(UIScrollView *)scrollView;

/**
 *  下拉刷新调用的方法
 */
-(void)headRefreshAction;

/**
 *  上拉刷新调用的方法
 */
-(void)footRefreshAction;

@end
