//
//  CSRegistViewController.m
//  CaiLianShe
//
//  Created by 李津通 on 15/12/7.
//  Copyright © 2015年 chenny. All rights reserved.
//

#import "TKRegistViewController.h"
#import "TKForgetPassWordViewController.h"
#import "TKEmailLoginViewController.h"

//注册登录页面
@interface TKRegistViewController ()


@end
@implementation TKRegistViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //隐藏tabbar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.view addSubview:self.loginRegisterView];

}

- (TKLoginRegistView *)loginRegisterView{
    if (!_loginRegisterView) {
        _loginRegisterView = [[TKLoginRegistView alloc] initWithFrame:self.view.frame];
        __weak typeof(self) weakSelf = self;
        //点击登录按钮
        _loginRegisterView.loginBlock = ^(NSString *phone, NSString *passWord){
            [weakSelf clickLoginWithPhoneNumber:phone passWord:passWord];
        };
        //点击验证码按钮
        _loginRegisterView.registCaptchaBlock = ^(NSString *phone){
            [weakSelf clickcaptchaWithPhoneNumber:phone];
        };
        //点击注册按钮
        _loginRegisterView.registBlock = ^(NSString *phone, NSString *captcha, NSString *passWord, NSString *nickName){
            
            [weakSelf clickRegistWithPhoneNumber:phone captcha:captcha passWord:passWord nickName:nickName];
        };

        //点击忘记密码按钮
        _loginRegisterView.forgetBlock = ^(){
            [weakSelf forgetPassWord];
        };
        
        //点击邮箱登录按钮
        _loginRegisterView.emailBlock = ^(){
            [weakSelf loginWithEmail];
        };
        
        //点击注册界面
        _loginRegisterView.clickRegistViewBlock = ^(){
            weakSelf.title = @"注册";
        };
        
        //点击登录界面
        _loginRegisterView.clickLoginViewBlock = ^(){
            weakSelf.title = weakSelf.titleString;
        };
    }
    return _loginRegisterView;
}

//验证码倒计时方法
-(void)timeCountDown{
    _loginRegisterView.timeCount--;
    NSString *roomsStr = [NSString stringWithFormat:@"%ld秒",(long)_loginRegisterView.timeCount];
    _loginRegisterView.timeLabel.text = roomsStr;
    if (_loginRegisterView.timeCount == 0)
    {
        [_loginRegisterView.timer invalidate];
        _loginRegisterView.captchaButton.enabled = YES;
        _loginRegisterView.timeLabel.text = @"再次发送";
    }
}

#pragma mark  登录界面，点击登录按钮
- (void)clickLoginWithPhoneNumber:(NSString *)phoneNumber passWord:(NSString *)passWord{
    
}

#pragma mark 验证码
- (void)clickcaptchaWithPhoneNumber:(NSString *)phoneNumber{

}

#pragma mark 注册新用户
- (void)clickRegistWithPhoneNumber:(NSString *)phoneNumber captcha:(NSString *)captcha passWord:(NSString *)passWord nickName:(NSString *)nickName{

}

#pragma mark 忘记密码
- (void)forgetPassWord{
    
}

#pragma mark 邮箱登陆
- (void)loginWithEmail{
    
}


//验证手机号码是否为纯数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断昵称是否符合要求
- (BOOL)checkNickName:(NSString *)nickName{
    
    NSString *regex = @"[A-Za-z0-9_\\u4e00-\\u9fa5]{2,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([pred evaluateWithObject:nickName]) {
        return YES;
    }else{
        return NO;
    }
}

@end
