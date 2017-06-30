//
//  LJForgetPassWordView.h
//  news
//
//  Created by 奥那 on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKForgetPassWordView : UIView

@property(nonatomic, copy) void (^commitBlock)(NSString *,NSString *,NSString *);
@property(nonatomic, copy) void (^captchaBlock)(NSString *);

@property (nonatomic, strong)UILabel *timeLabel;//验证码button的显示label
@property (nonatomic, strong)UITextField *phoneTextField;//手机号码输入框
@property (nonatomic, strong)UITextField *passWordField;//密码输入框
@property (nonatomic, strong)UITextField *captchaField;//验证码输入框
@property (nonatomic, strong)UIButton *captchaButton;//发送验证码button
@property (nonatomic, strong)UIButton *confirmBtn;//设置新密码

@property (nonatomic, strong)UIView *setView;//重置密码view
@property (nonatomic, strong)UIView *inputView;
@property (nonatomic, strong)NSArray *lineArray;

@end
