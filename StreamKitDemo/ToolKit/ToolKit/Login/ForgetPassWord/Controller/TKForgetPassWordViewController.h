//
//  CSForgetPWViewController.h
//  CaiLianShe
//
//  Created by 李津通 on 15/12/9.
//  Copyright © 2015年 chenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKForgetPassWordView.h"

@interface TKForgetPassWordViewController : UIViewController
@property (nonatomic, strong)TKForgetPassWordView *forgetPassWordView;

@property (nonatomic, strong)NSTimer *timer;//发送验证码按钮倒计时计时器
@property (nonatomic, assign)NSInteger timeCount;//验证码按钮倒计时数字


//点击发送验证码
- (void)clickcaptcha:(NSString *)phoneNumber;

//点击“提交新密码”按钮，重置密码
- (void)clickSubmit:(NSString *)phoneNumber captcha:(NSString *)captcha password:(NSString *)password;

//验证码倒计时方法
-(void)timeCountDown;

//验证手机号码是否为纯数字
- (BOOL)isPureInt:(NSString*)string;
@end
