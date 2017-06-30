//
//  TKLoginRegistView.m
//  CaiLianShe
//
//  Created by 李津通 on 15/12/21.
//  Copyright © 2015年 chenny. All rights reserved.
//
#import "TKLoginRegistView.h"
#import "TPKeyboardAvoidingScrollView.h"

#define kHasLoginWithEmail 1

@interface TKLoginRegistView()<UITextFieldDelegate,UIScrollViewDelegate>

{
    CGFloat width;
    CGFloat height;
}

@property (nonatomic, strong)TPKeyboardAvoidingScrollView *scrollView;//登录页面scrollview
@property (nonatomic, strong)UIButton *emailButton;


@end

@implementation TKLoginRegistView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    
    self.hasEmail = YES;
    
    //创建view
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditAction:)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.scrollView];
    [_scrollView addSubview:self.registView];
    [_scrollView addSubview:self.loginView];
    
}

//创建登录view
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(0, height+ 60);
        
        //登录view
        _loginRegistView = [[UIView alloc] initWithFrame:CGRectMake(22, 30, width-44, 47)];
        _loginRegistView.backgroundColor = [UIColor whiteColor];
        _loginRegistView.clipsToBounds = YES;
        _loginRegistView.layer.masksToBounds = YES;
        _loginRegistView.layer.cornerRadius = 6;
        _loginRegistView.layer.borderWidth = 1;
        _loginRegistView.layer.borderColor = [UIColor colorWithRed:28/255.0 green:136/255.0 blue:208/255.0 alpha:1].CGColor;
        [_scrollView addSubview:_loginRegistView];
        
        //分段选择器--登录
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(0, 0, (width - 44)/2, 47);
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.backgroundColor = [UIColor colorWithRed:28/255.0 green:136/255.0 blue:208/255.0 alpha:1];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:17];

        _loginButton.layer.borderColor = [UIColor grayColor].CGColor;
        [_loginButton addTarget:self action:@selector(clickLoginView) forControlEvents:UIControlEventTouchUpInside];
        [_loginRegistView addSubview:_loginButton];
        
        //分段选择器--注册
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.frame = CGRectMake(CGRectGetMaxX(_loginButton.frame), 0, (width - 44)/2, 47);
        [_registButton setTitle:@"注册新用户" forState:UIControlStateNormal];
        [_registButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:17];

        [_registButton addTarget:self action:@selector(clickRegistView) forControlEvents:UIControlEventTouchUpInside];
        [_loginRegistView addSubview:_registButton];
        
        
    }
    return _scrollView;
}

- (UIView *)loginView{
    if (!_loginView) {
        //登录view
        _loginView = [[UIView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(_loginRegistView.frame)+33, width - 37, 300)];
        
        //输入view
        _loginInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width - 37, 132)];
        _loginInputView.backgroundColor = [UIColor whiteColor];
        _loginInputView.layer.masksToBounds = YES;
        _loginInputView.layer.cornerRadius = 6;
        [_loginView addSubview:_loginInputView];
        
        //手机icon
        _phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(11, 18, 18, 32)];
        _phoneImg.image = [[UIImage imageNamed:@"login_phone"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_loginView addSubview:_phoneImg];
        
        //登录手机输入框
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_phoneImg.frame)+14, 0, _loginInputView.frame.size.width - 47, 66)];
        _phoneTextField.font = [UIFont systemFontOfSize:17];

        _phoneTextField.placeholder = @"您的手机号";
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_phoneTextField setValue:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        _phoneTextField.delegate = self;
        [_loginInputView addSubview:_phoneTextField];
        
        //分隔线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(_phoneTextField.frame), _loginInputView.frame.size.width-18, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.linesArray addObject:line];
        [_loginInputView addSubview:line];
        
        //密码icon
        _passwordImg = [[UIImageView alloc] initWithFrame:CGRectMake(11, CGRectGetMaxY(line.frame) + 20, 19, 26)];
        _passwordImg.image = [[UIImage imageNamed:@"login_password"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_loginView addSubview:_passwordImg];
        
        //登录密码输入框
        _passWordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_passwordImg.frame)+14, CGRectGetMaxY(line.frame), _loginInputView.frame.size.width-47, 66)];
        _passWordField.font = [UIFont systemFontOfSize:17];
        _passWordField.delegate = self;
        _passWordField.secureTextEntry = YES;
        _passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_loginInputView addSubview:_passWordField];
        
        //登录密码输入框placeholder
        _passWordField.placeholder = @"密码";
        [_passWordField setValue:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        
        //email --icon
        _emailImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_loginInputView.frame)+20, 20, 15)];
        _emailImg.image = [[UIImage imageNamed:@"login_email"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_loginView addSubview:_emailImg];
        
        //邮箱登录button
        self.emailButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.emailButton.frame = CGRectMake(CGRectGetMaxX(_emailImg.frame), CGRectGetMaxY(_loginInputView.frame)+13, 110, 30);
        [self.emailButton setTitle:@"使用邮箱登录" forState:UIControlStateNormal];
        self.emailButton.titleLabel.font = [UIFont systemFontOfSize:17];
        //Todo:颜色待定
        [self.emailButton setTitleColor:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1] forState:UIControlStateNormal];
        [self.emailButton addTarget:self action:@selector(clickEmail) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:self.emailButton];
        
        //忘记密码button
        UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeSystem];
        forgetButton.frame = CGRectMake(CGRectGetMaxX(_loginView.frame)-100, CGRectGetMaxY(_loginInputView.frame)+13, 70, 30);
        [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        forgetButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [forgetButton setTitleColor: [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1] forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(clickForget) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:forgetButton];
        
        //登录button
        _confirmLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmLoginButton.frame = CGRectMake(4, CGRectGetMaxY(_loginInputView.frame)+56, width - 45, 47);
        [_confirmLoginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_confirmLoginButton setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        [_confirmLoginButton addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:_confirmLoginButton];
    }
    return _loginView;
}

//注册view
- (UIView *)registView{
    if (!_registView) {
        //注册view
        _registView = [[UIView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(_loginRegistView.frame)+33, width - 37, height)];
        
        _registInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width - 37, 265)];
        _registInputView.backgroundColor = [UIColor whiteColor];
        _registInputView.layer.masksToBounds = YES;
        _registInputView.layer.cornerRadius = 6;
        [_registView addSubview:_registInputView];
        
        //注册手机号输入框
        _phoneTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(24, 0, _registInputView.frame.size.width-130, 66)];
        _phoneTextField2.keyboardType = UIKeyboardTypePhonePad;
        _phoneTextField2.font = [UIFont systemFontOfSize:17];
        _phoneTextField2.placeholder = @"+86";
        [_phoneTextField2 setValue:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        _phoneTextField2.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField2.delegate = self;
        [_registInputView addSubview:_phoneTextField2];
        
        //验证码发送button
        _captchaButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _captchaButton.frame = CGRectMake(CGRectGetMaxX(_phoneTextField2.frame), 15, 96, 36);
        _captchaButton.layer.masksToBounds = YES;
        _captchaButton.layer.cornerRadius = 6;
        [_captchaButton setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        [_captchaButton addTarget:self action:@selector(clickcaptcha) forControlEvents:UIControlEventTouchUpInside];
        [_registInputView addSubview:_captchaButton];
        
        //验证码button显示label
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 96, 36)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = @"发送验证码";
        [_captchaButton addSubview:_timeLabel];
        
        //分隔线
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(_phoneTextField2.frame), _registInputView.frame.size.width-18, 0.5)];
        line1.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.linesArray addObject:line1];
        [_registInputView addSubview:line1];
        
        //验证码输入框
        _captchaField = [[UITextField alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(line1.frame), _registInputView.frame.size.width-28, 66)];
        _captchaField.font = [UIFont systemFontOfSize:17];
        _captchaField.placeholder = @"验证码";
        _captchaField.delegate = self;
        [_captchaField setValue:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        _captchaField.keyboardType = UIKeyboardTypeNumberPad;
        _captchaField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_registInputView addSubview:_captchaField];
        
        //分割线
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(_captchaField.frame), _registInputView.frame.size.width-18, 0.5)];
        line2.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.linesArray addObject:line2];
        [_registInputView addSubview:line2];
        
        //注册密码输入框
        _passWordField2 = [[UITextField alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(line2.frame), _registInputView.frame.size.width-28, 66)];
        _passWordField.font = [UIFont systemFontOfSize:17];
        _passWordField2.delegate = self;
        _passWordField2.secureTextEntry = YES;
        _passWordField2.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_registInputView addSubview:_passWordField2];
        
        //注册密码输入框placeholder
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"设置密码  6-15个字符"];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(0,4)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] range:NSMakeRange(4,string.length-4)];
        _passWordField2.attributedPlaceholder = string;
        
        //分隔线
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(_passWordField2.frame), _registInputView.frame.size.width-18, 0.5)];
        line3.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.linesArray addObject:line3];
        [_registInputView addSubview:line3];
        
        //昵称输入框
        _nickNameField = [[UITextField alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(line3.frame), _registInputView.frame.size.width-28, 66)];
        _nickNameField.font = [UIFont systemFontOfSize:17];
        _nickNameField.delegate = self;
        _nickNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nickNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [_registInputView addSubview:_nickNameField];
        
        //昵称输入框placeholder
        NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"昵称  2-16个字 支持英文、下划线"];
        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] range:NSMakeRange(0,2)];
        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] range:NSMakeRange(4,string1.length-4)];
        _nickNameField.attributedPlaceholder = string1;
        
        //注册button
        _confirmRegistButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmRegistButton.frame = CGRectMake(4, CGRectGetMaxY(_registInputView.frame)+40, width - 45, 47);
        [_confirmRegistButton setTitle:@"注册" forState:UIControlStateNormal];
        [_confirmRegistButton setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        [_confirmRegistButton addTarget:self action:@selector(clickRegist) forControlEvents:UIControlEventTouchUpInside];
        [_registView addSubview:_confirmRegistButton];
        
        _registView.hidden = YES;
    }
    return _registView;
}

-(NSMutableArray *)linesArray{
    if (!_linesArray) {
        _linesArray = [NSMutableArray array];
    }
    return _linesArray;
}

- (void)setHasEmail:(BOOL *)hasEmail {
    
    if (!hasEmail) {
        self.emailImg.hidden = !hasEmail;
        self.emailButton.hidden = !hasEmail;
    }
}

#pragma mark button的响应事件
- (void)clickLoginView{
    //点击“登录”恢复“注册”页面
    _loginView.hidden = NO;
    _registView.hidden = YES;
    _captchaField.text = @"";
    _phoneTextField2.text = @"";
    _passWordField2.text = @"";
    _nickNameField.text = @"";
    _phoneTextField2.text = @"";
    _phoneTextField2.placeholder = @"+86";
    
    [_timer invalidate];
    _captchaButton.enabled = YES;
    _timeLabel.text = @"发送验证码";
    
    //点击“登录”改变“注册”按钮颜色
    _loginButton.backgroundColor = [UIColor colorWithRed:28/255.0 green:136/255.0 blue:208/255.0 alpha:1];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registButton.backgroundColor = [UIColor whiteColor];
    [_registButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self endEditing:YES];
    
    if (_clickLoginViewBlock) {
        _clickLoginViewBlock();
    }
}

- (void)clickRegistView{
    //点击“注册”恢复“登录”页面
    _registView.hidden = NO;
    _loginView.hidden = YES;
    _phoneTextField.text = @"";
    _passWordField.text = @"";
    
    //点击“注册”改变“登录”按钮颜色
    _registButton.backgroundColor = [UIColor colorWithRed:28/255.0 green:136/255.0 blue:208/255.0 alpha:1];
    [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _loginButton.backgroundColor = [UIColor whiteColor];
    [_registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self endEditing:YES];
    
    if (_clickRegistViewBlock) {
        _clickRegistViewBlock();
    }
}

#pragma mark  登录界面，点击登录按钮
- (void)clickLogin{
    if (_loginBlock) {
        _loginBlock(_phoneTextField.text, _passWordField.text);
    }
    [self endEditing:YES];
}

#pragma mark 验证码
- (void)clickcaptcha{
    if (_registCaptchaBlock) {
        _registCaptchaBlock(_phoneTextField2.text);
    }
    [self endEditing:YES];
}

#pragma mark 注册新用户
- (void)clickRegist{
    if (_registBlock) {
        _registBlock(_phoneTextField2.text, _captchaField.text, _passWordField2.text, _nickNameField.text);
    }
    [self endEditing:YES];
}

//点击email登录
- (void)clickEmail{
    if (_emailBlock){
        _emailBlock();
    }
    [self endEditing:YES];
}

//点击忘记密码
- (void)clickForget{
    if (_forgetBlock) {
        _forgetBlock();
    }
    [self endEditing:YES];
}

- (void)endEditAction:(UITapGestureRecognizer *)tap{
    [self endEditing:YES];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _phoneTextField) {
        [_phoneTextField resignFirstResponder];
        [_passWordField becomeFirstResponder];
    } else if(textField == _passWordField){
        [_passWordField resignFirstResponder];
    } else if (textField == _phoneTextField2) {
        [_phoneTextField2 resignFirstResponder];
        [_captchaField becomeFirstResponder];
    } else if(textField == _captchaField){
        [_captchaField resignFirstResponder];
        [_passWordField2 becomeFirstResponder];
    } else if (textField == _passWordField2) {
        [_passWordField2 resignFirstResponder];
        [_nickNameField becomeFirstResponder];
    } else if (textField == _nickNameField) {
        [_nickNameField resignFirstResponder];
    }
    return YES;
}

//电话号码、验证码只能输入纯数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneTextField || textField== _phoneTextField2 || textField == _captchaField) {
        return [self validateNumber:string];
    }
    return YES;
}
//电话号码、验证码只能输入纯数字判断方法
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


@end
