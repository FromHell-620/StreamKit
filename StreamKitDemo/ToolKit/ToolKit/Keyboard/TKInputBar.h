//
//  TKInputBar.h
//  ToolKit
//
//  Created by chunhui on 16/4/19.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKKeyboardCommon.h"

@protocol TKInputBarDelegate;

@interface TKInputBar : UIView

@property(nonatomic , weak) id<TKInputBarDelegate> delegate;

@property(nonatomic , assign) TKKeyboardMode mode;
@property(nonatomic , assign) NSUInteger maxInputCount;
@property(nonatomic , assign) BOOL overMaxCanInput;//超过最多后是否能继续输入，默认 是
@property(nonatomic , copy)   NSString *placeholder;
@property(nonatomic , strong) UIColor *sendBgColor;//发送背景颜色

@property(nonatomic , copy)   void (^updateModeBlock)(TKKeyboardMode mode);
@property(nonatomic , copy)   void (^inputOverLimitBlock)(NSInteger currentInputCount);



-(instancetype)initWithFrame:(CGRect)frame barMode:(TKKeyboardBarMode)barMode;

-(CGFloat)showHeight;

-(void)setText:(NSString *)text;

-(NSString *)toSendText;

@end

@protocol TKInputBarDelegate <NSObject>

@optional
- (BOOL)inputBarWillStartEditing:(TKInputBar*)inputBar withMode:(TKKeyboardMode)mode;
- (void)inputBarDidStartEditing:(TKInputBar*)inputBar;
- (void)inputBarDidEndEditing:(TKInputBar*)inputBar;
- (BOOL)inputBarShouldReturn:(TKInputBar*)inputBar;
- (void)inputBar:(TKInputBar*)inputBar willChangeToFrame:(CGRect)frame withDuration:(NSTimeInterval)duration;
- (void)inputBar:(TKInputBar*)inputBar didChangeToFrame:(CGRect)frame;
- (void)inputBar:(TKInputBar*)inputBar didChangeToMode:(TKKeyboardMode)mode;

@end
