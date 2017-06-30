//
//  TKCommons.h
//  ToolKit
//
//  Created by chunhui on 16/3/11.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#ifndef TKCommons_h
#define TKCommons_h

extern NSString *kRequestNetErrorTip;
extern NSString *kRequestFailedTip;


typedef NS_ENUM(NSInteger, KENetworkErrors) {
    KENetWorkErrorCode = 10013, //网络错误
    KENoDataErrorCode = 20022,  //没有数据
};

typedef NS_ENUM(NSInteger, TKDataFreshType) {
    TKDataFreshTypeRefresh,//默认从0开始
    TKDataFreshTypeLoadMore,
};


#endif /* TKCommons_h */
