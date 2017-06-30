//
//  TKAdScrollView.h
//  ToolKit
//
//  Created by chunhui on 15/11/1.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , TKBannerPageControlLocation) {
    kTKBannerLocationLeft,
    kTKBannerLocationCenter,
    kTKBannerLocationRight,
};

@protocol TKBannerViewDelegate;
/**
 *  显示banner view
 *  添加的view controller 需要设置automaticallyAdjustsScrollViewInsets 为false bur
 *  会出现collectionview显示问题
 */
@interface TKBannerView : UIView

@property(nonatomic , assign) CGFloat showDuration;//每个展示的间隔
@property(nonatomic , weak)   id<TKBannerViewDelegate>delegate;

@property(nonatomic , assign) TKBannerPageControlLocation pageLocation;
@property(nonatomic , assign) CGSize pageIndicatorSize;
@property(nonatomic , strong) UIColor *pageIndicatorTintColor;
@property(nonatomic , strong) UIColor *currentPageIndicatorTintColor;
@property(nonatomic , assign) BOOL cycleShow;//是否单向循环滚动
@property(nonatomic , assign) BOOL circlePageControl;//page是否的圆点
@property(nonatomic , assign) CGFloat bannerScrollHeight;
@property(nonatomic , assign) BOOL titleInCell;//title在cell里面
@property(nonatomic , strong) UIImage *bannerBg;//当title in cell为true时有效
@property(nonatomic , strong , readonly) UILabel *titleLabel;

@property(nonatomic , strong , readonly) UIView *bannerView;

-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

-(void)updateWithItems:(NSArray *)items;

-(void)startScroll;

-(void)stopScroll;


@end


@interface TKBannerItem : NSObject

@property(nonatomic , copy) NSString *imgUrl;
@property(nonatomic , strong) UIImage *placeHolder;
@property(nonatomic , copy) NSString *title;
@property(nonatomic , assign) BOOL canTap;//是否可以点击 默认 yes
@property(nonatomic , copy) NSString *linkUrl;//点击跳转的url

@end


@protocol TKBannerViewDelegate <NSObject>

-(void)tapItem:(TKBannerItem *)item;

@end
