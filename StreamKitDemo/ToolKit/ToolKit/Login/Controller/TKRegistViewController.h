//
//  CSRegistViewController.h
//  CaiLianShe
//
//  Created by 李津通 on 15/12/7.
//  Copyright © 2015年 chenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKLoginRegistView.h"

@interface TKRegistViewController : UIViewController

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, strong) TKLoginRegistView *loginRegisterView;

//登录
- (void)clickLoginWithPhoneNumber:(NSString *)phoneNumber passWord:(NSString *)passWord;

//发送验证码
- (void)clickcaptchaWithPhoneNumber:(NSString *)phoneNumber;

//注册
- (void)clickRegistWithPhoneNumber:(NSString *)phoneNumber captcha:(NSString *)captcha passWord:(NSString *)passWord nickName:(NSString *)nickName;

//忘记密码
- (void)forgetPassWord;

//邮箱登陆
- (void)loginWithEmail;

-(void)timeCountDown;

//验证手机号码是否为纯数字
- (BOOL)isPureInt:(NSString*)string;

//判断昵称是否符合要求
- (BOOL)checkNickName:(NSString *)nickName;

@end
