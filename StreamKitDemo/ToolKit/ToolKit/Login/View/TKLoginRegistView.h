//
//  CSLoginSignView.h
//  CaiLianShe
//
//  Created by 李津通 on 15/12/21.
//  Copyright © 2015年 chenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKLoginRegistView : UIView

@property(nonatomic, copy) void (^loginBlock)(NSString *,NSString *);
@property(nonatomic, copy) void (^registBlock)(NSString *, NSString *, NSString *, NSString *);
@property(nonatomic, copy) void (^registCaptchaBlock)(NSString *);
@property(nonatomic, copy) void (^emailBlock)();
@property(nonatomic, copy) void (^forgetBlock)();
@property(nonatomic, copy) void (^clickRegistViewBlock)();
@property(nonatomic, copy) void (^clickLoginViewBlock)();

@property (nonatomic, strong)NSTimer *timer;//发送验证码按钮倒计时计时器
@property (nonatomic, assign)NSInteger timeCount;//验证码按钮倒计时数字
@property (nonatomic, strong)UILabel *timeLabel;//验证码button的显示label
@property (nonatomic, strong)UIButton *captchaButton;//发送验证码button
@property (nonatomic, strong)UIView *loginView;//登录view
@property (nonatomic, strong)UIView *registView;//注册view

@property (nonatomic, strong)UIView *loginRegistView;//登录注册分段选择器view
@property (nonatomic, strong)UITextField *phoneTextField;//登录手机号码输入框
@property (nonatomic, strong)UITextField *passWordField;//登录密码输入框
@property (nonatomic, strong)UITextField *captchaField;//验证码输入框
@property (nonatomic, strong)UITextField *phoneTextField2;//注册手机号码输入框
@property (nonatomic, strong)UITextField *passWordField2;//注册密码输入框
@property (nonatomic, strong)UITextField *nickNameField;//昵称输入框
@property (nonatomic, strong)UIButton *loginButton;//登录button
@property (nonatomic, strong)UIButton *registButton;//注册button

@property (nonatomic, strong)UIButton *confirmLoginButton;//登录button
@property (nonatomic, strong)UIButton *confirmRegistButton;//注册button

@property (nonatomic, strong)UIView *loginInputView;//登录button
@property (nonatomic, strong)UIView *registInputView;//注册button

@property (nonatomic, strong)UIImageView *phoneImg;
@property (nonatomic, strong)UIImageView *passwordImg;
@property (nonatomic, strong)UIImageView *emailImg;

/**
 *  2016.6.8 添加删除email登录按钮接口
 */
@property (nonatomic, assign) BOOL hasEmail;

@property (nonatomic, strong)NSMutableArray *linesArray;

- (void)clickLoginView;

@end
