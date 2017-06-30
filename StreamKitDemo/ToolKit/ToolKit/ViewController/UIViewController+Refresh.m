//
//  LJBaseViewController+Refresh.m
//  news
//
//  Created by chunhui on 15/12/6.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "UIViewController+Refresh.h"
#import "MJRefresh.h"

@implementation UIViewController (Refresh)


-(void)addRefreshView:(UIScrollView *)scrollView
{
    [self addHeaderRefreshView:scrollView];
    [self addFooterRefreshView:scrollView];
}

-(void)addHeaderRefreshView:(UIScrollView *)scrollView
{
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf headRefreshAction];
    }];
    scrollView.header = header;
}

-(void)addHeaderRefreshView:(UIScrollView *)scrollView callBack:(void(^)())callback
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        callback();
    }];
    scrollView.header = header;
}

-(void)addFooterRefreshView:(UIScrollView *)scrollView
{
    __weak typeof(self) weakSelf = self;
    MJRefreshFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footRefreshAction];
    }];
    
    scrollView.footer = footer;
    
}

-(void)addFooterRefreshView:(UIScrollView *)scrollView callBack:(void (^)())callback
{
    MJRefreshFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        callback();
    }];
    scrollView.footer = footer;
}

-(void)stopRefresh:(UIScrollView *)scrollView
{
    if ([scrollView.header isRefreshing]) {
        [scrollView.header endRefreshing];
    }
    if ([scrollView.footer isRefreshing]) {
        [scrollView.footer endRefreshing];
    }
}

-(void)startHeadRefresh:(UIScrollView *)scrollView
{
    if (scrollView.header && ![scrollView.header isRefreshing]) {
        [scrollView.header beginRefreshing];
    }
}

-(void)startFootRefresh:(UIScrollView *)scrollView
{
    if (scrollView.footer && ![scrollView.footer isRefreshing]) {
        [scrollView.footer beginRefreshing];
    }
}


-(void)headRefreshAction
{
    
}

-(void)footRefreshAction
{
    
}

@end
