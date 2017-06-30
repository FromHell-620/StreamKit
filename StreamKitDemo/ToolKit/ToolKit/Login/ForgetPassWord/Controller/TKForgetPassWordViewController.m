//
//  CSForgetPWViewController.m
//  CaiLianShe
//
//  Created by 李津通 on 15/12/9.
//  Copyright © 2015年 chenny. All rights reserved.
//

#import "TKForgetPassWordViewController.h"


//忘记密码
@interface TKForgetPassWordViewController ()<UITextFieldDelegate>


@end
@implementation TKForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    [self.view addSubview:self.forgetPassWordView];

}

- (TKForgetPassWordView *)forgetPassWordView{
    
    if (!_forgetPassWordView) {
        _forgetPassWordView = [[TKForgetPassWordView alloc] initWithFrame:self.view.frame];
        __weak typeof(self) weakSelf = self;
        
        //点击发送验证码
        _forgetPassWordView.captchaBlock = ^(NSString *phoneNumber){
            [weakSelf clickcaptcha:phoneNumber];
        };
        
        //点击提交新密码
        _forgetPassWordView.commitBlock = ^(NSString *phoneNumber,NSString *captcha,NSString *passWord){
            [weakSelf clickSubmit:phoneNumber captcha:captcha password:passWord];
        };
    }
    return _forgetPassWordView;
}

//验证码倒计时方法
-(void)timeCountDown{
            
    _timeCount--;
    NSString *roomsStr = [NSString stringWithFormat:@"%ld秒",(long)_timeCount];
    _forgetPassWordView.timeLabel.text = roomsStr;
    if (_timeCount == 0)
    {
        [_timer invalidate];
        _forgetPassWordView.captchaButton.enabled = YES;
        _forgetPassWordView.timeLabel.text = @"再次发送";

    }
}

//验证手机号码是否为纯数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark 点击发送验证码
- (void)clickcaptcha:(NSString *)phoneNumber{

}

#pragma mark 点击“提交新密码”按钮，重置密码
- (void)clickSubmit:(NSString *)phoneNumber captcha:(NSString *)captcha password:(NSString *)password{

}

@end
