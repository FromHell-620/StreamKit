//
//  TKInputPanelView.h
//  ToolKit
//
//  Created by chunhui on 16/4/19.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKInputEmojiItem;

@protocol TKInputPanelViewDelegate;

@interface TKInputPanelView : UIView

@property(nonatomic , weak) id<TKInputPanelViewDelegate> delegate;
@property(nonatomic , strong) UIColor *sendBgColor;//发送背景颜色

+(TKInputPanelView *)sharedInstance;


@end


@protocol TKInputPanelViewDelegate <NSObject>

-(void)panel:(TKInputPanelView *)panel chooseItem:(TKInputEmojiItem *)item;
-(void)panelDoDelete:(TKInputPanelView *)panel;
-(void)panelDoSend:(TKInputPanelView *)panel;

@end